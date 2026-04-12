extends VehicleBody3D


@export var SPEEDOMETER_LABEL: Label
@export var GearLabel: Label

@onready var WheelFL = $VehicleWheelFL
@onready var WheelFR = $VehicleWheelFR
@onready var WheelRL = $VehicleWheelRL
@onready var WheelRR = $VehicleWheelRR


@export var MAX_STEER = 0.5
@export var ENGINE_POWER = 50000
@export var BRAKE_POWER = 25

@export var control: Control
@export var steering_slider: HSlider
@export var gas_button: TouchScreenButton
@export var brake_button: TouchScreenButton

@export var self_node: VehicleBody3D

@export var rev_disp: HBoxContainer

var stearing_speed = 1.2
var returning_speed = 1.5

var direction = 1
var speed

var brake_balance = 0.8

var air_density = 1.225
var form_coefficent = .5
var surface = 2
var Cl = -1.8
var down_force

var gear_ratio = [-3, 0, 3.15, 2.29, 1.85, 1.53, 1.27, 1]
var actual_gear = 1
var drop_gear = 1.28
var CWP = 2.88
var rpm
var torque
var gear_up = false

var dt = 0


@export var CURRENT_TIME_LABEL: Label
@export var FASTEST_TIME_LABEL: Label
@export var LAST_LAP: Label

var lap_stert_time=0
var last_lap=0
var last_lap_print
var current_time
var current_time_minute
var fastest_lap_minute
var fastest_lap_print

var skid_marks = []
var last_skid_pos = [Vector3.ZERO, Vector3.ZERO, Vector3.ZERO, Vector3.ZERO]

var fastest_time = 500000000

var reset_position = Vector3()
var reset = false




func air_resistance(spd, dens, form, surf):
	return (0.5 * dens *spd*spd*form*surf)
	
func down_force_calc(spd, dens, form, surf):
	return (0.5 * dens * spd*spd * surf * form)
	

func steering_value(input, dead_zone, max_val):
	if abs(input) < dead_zone:
		return 0
	elif input > 0:
		return (input-dead_zone) * max_val * (1+dead_zone)
	else:
		return (input+dead_zone) * max_val * (1+dead_zone) 


func torque_calc(x, a, b, c):
	return a*x*x + b*x + c
	

func rev_disp_set(rpm, rev_disp):
	for i in range(len(rev_disp.get_children())):
		rev_disp.get_child(i).color = Color(0,0,0)
	for i in range((rpm-6000)/333):
		if i < 3:
			rev_disp.get_child(i).color = Color(0,1,0)
		elif i < 6:
			rev_disp.get_child(i).color = Color(1,1,0)
		elif i < 9:
			rev_disp.get_child(i).color = Color(1,0,0)


func _physics_process(delta):
	var wheel_list = [WheelFL, WheelFR, WheelRL, WheelRR]
	
	WheelFL.suspension_stiffness = Global.suspension_stiffnessF
	WheelFR.suspension_stiffness = Global.suspension_stiffnessF
	WheelRL.suspension_stiffness = Global.suspension_stiffnessR
	WheelRR.suspension_stiffness = Global.suspension_stiffnessR
	GearLabel.text = str(actual_gear)
	
	speed = linear_velocity.length()
	rpm = abs((speed/(2*3.14*.3))*gear_ratio[actual_gear+1] * drop_gear * CWP * 60)
	if rpm < 1000:
		rpm = 1000
	
	rev_disp_set(rpm, rev_disp)
	
	if Global.steering_type == "Button":
		control.visible = false
		#Global.gear_box_type = "m"
		if steering>0:
			if Input.get_axis("right", "left") > steering:
				steering = move_toward(steering, Input.get_axis("right","left") * MAX_STEER, delta *stearing_speed)
			else:
				steering = move_toward(steering, Input.get_axis("right","left") * MAX_STEER, delta *returning_speed)
		elif steering<0:
			if Input.get_axis("right", "left") < steering:
				steering = move_toward(steering, Input.get_axis("right","left") * MAX_STEER, delta *stearing_speed)
			else:
				steering = move_toward(steering, Input.get_axis("right","left") * MAX_STEER, delta *returning_speed)
		else:
			steering = move_toward(steering, Input.get_axis("right","left") * MAX_STEER, delta *stearing_speed)
			
		if rpm < 9000 and dt > 15:
			torque = torque_calc(rpm,-1/56250000,115000/56250000, 0.5)
			engine_force = int(Input.is_action_pressed("up")) * ENGINE_POWER * gear_ratio[actual_gear+1] * drop_gear * CWP  * torque
		else:
			engine_force = 0
			for wheel in wheel_list:
				if wheel.use_as_traction:
					WheelRL.brake = BRAKE_POWER
		WheelFL.brake = int(Input.is_action_pressed("down")) * BRAKE_POWER * brake_balance
		WheelFR.brake = int(Input.is_action_pressed("down")) * BRAKE_POWER * brake_balance
		WheelRL.brake = int(Input.is_action_pressed("down")) * BRAKE_POWER * (1-brake_balance)
		WheelRR.brake = int(Input.is_action_pressed("down")) * BRAKE_POWER * (1-brake_balance)
			

	if Global.steering_type == "Slider":
		control.visible = true
		Global.gear_box_type = "automatic"
		steering  = steering_value(steering_slider.value*-1, .1, MAX_STEER)
		
		if rpm < 9000 and dt > 15:
			torque = torque_calc(rpm,-1/56250000,115000/56250000, 0.5)/2
			engine_force = int(gas_button.is_pressed()) * ENGINE_POWER * gear_ratio[actual_gear+1] * drop_gear * CWP  * torque
		else:
			engine_force = 0
		

				
		WheelFL.brake = int(brake_button.is_pressed()) * BRAKE_POWER * brake_balance
		WheelFR.brake = int(brake_button.is_pressed()) * BRAKE_POWER * brake_balance
		WheelRL.brake = int(brake_button.is_pressed()) * BRAKE_POWER * (1-brake_balance)
		WheelRR.brake = int(brake_button.is_pressed()) * BRAKE_POWER * (1-brake_balance)
		
		
	for i in range(len(wheel_list)):
		if wheel_list[i].get_skidinfo() < 0.8 and wheel_list[i].global_position.distance_to(last_skid_pos[i]) > 0:
			var decal = preload("res://Scenes/skid_mark.tscn").instantiate()
			decal.position = wheel_list[i].global_position
			decal.position.y -= .3
			get_tree().root.add_child(decal)
			last_skid_pos[i] = wheel_list[i].global_position
			skid_marks.append(decal)
			#print(len(skid_marks))
	
			
	if Input.is_action_pressed("gear_up") and dt > 15 and actual_gear < 6 and Global.gear_box_type == "manual":
		actual_gear += 1
		dt =0
		
	if Input.is_action_pressed("gear_down") and dt > 15 and actual_gear>-1 and Global.gear_box_type == "manual":
		actual_gear -= 1
		dt = 0
	
	
	if rpm > 8800 and actual_gear < 6 and  Global.gear_box_type == "automatic" and dt > 15:
		actual_gear += 1
		dt = 0
		gear_up = true
	elif rpm < 6500 and actual_gear > 1 and  Global.gear_box_type == "automatic" and dt > 15:
		if gear_up and dt > 60:
			actual_gear -= 1
			dt = 0
			gear_up = false
		elif not gear_up and dt > 15:
			actual_gear -= 1
			dt = 0
			
#	print("")
#	print(str(WheelFL.get_skidinfo()) + "\t" + str(WheelFR.get_skidinfo()))
#	print(str(WheelRL.get_skidinfo()) + "\t" + str(WheelRR.get_skidinfo()))
#	print()
#	print(str(engine_force)+ "  " + str(brake))
	
	var air_res = linear_velocity.normalized()	 * air_resistance(speed, air_density, form_coefficent, surface)
	down_force = -global_transform.basis.y #Vector3(0,down_force_calc(speed, air_density, Cl, surface), 0)
	apply_central_force(down_force + air_res)
	dt += 1
	
	
	
	if SPEEDOMETER_LABEL:
		SPEEDOMETER_LABEL.text = str(int(linear_velocity.length()*3.6))
		
	
	if CURRENT_TIME_LABEL:
		if lap_stert_time != 0:
			current_time_minute = 0
		#print("finish: ", last_lap)
			current_time = float(Time.get_ticks_msec() - lap_stert_time) / 1000
			while current_time >= 60:
				current_time_minute += 1
				current_time -= 60
			CURRENT_TIME_LABEL.text = str("Current lap: " + str(current_time_minute) + ":" + str(current_time))
		else:
			CURRENT_TIME_LABEL.text = str("Current lap: ")
	
	if LAST_LAP:
		var last_lap_minute = 0
		last_lap_print = last_lap
		if last_lap == 0:
			LAST_LAP.text = str("Last lap: ")
		elif last_lap >= 60:
			while last_lap_print >= 60:
				last_lap_minute += 1
				last_lap_print -= 60
				LAST_LAP.text = "Last lap: " + str(last_lap_minute) + ":" + str(last_lap_print)
		else:
			LAST_LAP.text = "Last lap: " + str(last_lap_minute) + ":" + str(last_lap_print)
		
	
	if FASTEST_TIME_LABEL:
		if fastest_time != 500000000:
			fastest_lap_minute = 0
			fastest_lap_print = fastest_time
			if fastest_lap_print >= 60:
				while fastest_time > 60:
					fastest_lap_minute += 1
					fastest_lap_print -= 60
					if fastest_time < 10:
						FASTEST_TIME_LABEL.text = "Fastest lap: " + str(fastest_lap_minute) + ":0" + str(fastest_lap_print)
					else:
						FASTEST_TIME_LABEL.text = "Fastest lap: " + str(fastest_lap_minute) + ":" + str(fastest_lap_print)
			else:
				FASTEST_TIME_LABEL.text = "Fastest lap: " + str(fastest_lap_minute) + ":" + str(fastest_lap_print)
		else:
			FASTEST_TIME_LABEL.text = str("Fastest lap: ")

	if reset:
		self_node.position = reset_position
		reset = false
		linear_velocity = Vector3(0,0,0)
		lap_stert_time = 0
	
func _on_finish_line_body_entered(self_node) -> void:
	if lap_stert_time!=0:
		last_lap = float(Time.get_ticks_msec() - lap_stert_time)/1000
		#print(Time.get_ticks_msec())
		if last_lap < fastest_time:
			fastest_time = float(last_lap)
		#print("finish: ", last_lap)
	lap_stert_time = Time.get_ticks_msec()
	 # Replace with function body.

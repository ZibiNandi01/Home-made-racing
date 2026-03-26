extends VehicleBody3D


@export var SPEEDOMETER_LABEL: Label
@export var GearLabel: Label

@onready var WheelFL = $VehicleWheelFL
@onready var WheelFR = $VehicleWheelFR
@onready var WheelRL = $VehicleWheelRL
@onready var WheelRR = $VehicleWheelRR
var wheel_list = [WheelFL, WheelFR, WheelRL, WheelRR]

@export var MAX_STEER = 0.5
@export var ENGINE_POWER = 100
@export var BRAKE_POWER = 10

@export var steering_slider: HSlider

var stearing_speed = 1.2
var returning_speed = 1.5

var direction = 1
var speed
var pedal_sens = 2

var brake_balance = 0.8

var air_density = 1.225
var form_coefficent = .5
var surface = 2
var Cl = -1.8
var down_force

var gear_ratio = [0, 3.15, 2.29, 1.85, 1.53, 1.27, 1.28]
var actual_gear = 1
var drop_gear = 1.28
var CWP = 2.88

var dt = 0


func air_resistance(spd, dens, form, surf):
	return (0.5 * dens *spd*spd*form*surf)
	
func down_force_calc(spd, dens, form, surf):
	return (0.5 * dens * spd*spd * surf * form)
	

func steering_value(input, dead_zone, max):
	if abs(input) < dead_zone:
		return 0
	elif input > 0:
		return (input-dead_zone) * max * (1+dead_zone)
	else:
		return (input+dead_zone) * max * (1+dead_zone) 



func _physics_process(delta):
	
	WheelFL.suspension_stiffness = Global.suspension_stiffnessF
	WheelFR.suspension_stiffness = Global.suspension_stiffnessF
	WheelRL.suspension_stiffness = Global.suspension_stiffnessR
	WheelRR.suspension_stiffness = Global.suspension_stiffnessR
	
	GearLabel.text = str(actual_gear)
	
	if Global.steering_type == "Button":
		steering_slider.visible = false
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
			
	if Global.steering_type == "Slider":
		steering_slider.visible = true
		steering  = steering_value(steering_slider.value*-1, .1, MAX_STEER)
	
			
	if Input.is_action_pressed("gear_up") and dt > 15 and actual_gear < 6:
		actual_gear += 1
		dt =0
		
	if Input.is_action_pressed("gear_down") and dt > 15 and actual_gear>0:
		actual_gear -= 1
		dt = 0
	
	speed = linear_velocity.length()
	#print((speed/(2*3.14*.3))*gear_ratio[actual_gear] * drop_gear * CWP * 60)
	if (speed/(2*3.14*.3))*gear_ratio[actual_gear] * drop_gear * CWP * 60 < 9000:
		engine_force = int(Input.is_action_pressed("up")) * ENGINE_POWER * gear_ratio[actual_gear] * drop_gear * CWP /.3
	else:
		engine_force = 0
	
	WheelFL.brake = int(Input.is_action_pressed("down")) * BRAKE_POWER * brake_balance
	WheelFR.brake = int(Input.is_action_pressed("down")) * BRAKE_POWER * brake_balance
	WheelRL.brake = int(Input.is_action_pressed("down")) * BRAKE_POWER * (1-brake_balance)
	WheelRR.brake = int(Input.is_action_pressed("down")) * BRAKE_POWER * (1-brake_balance)
	print("")
	print(str(WheelFL.get_skidinfo()) + "\t" + str(WheelFR.get_skidinfo()))
	print(str(WheelRL.get_skidinfo()) + "\t" + str(WheelRR.get_skidinfo()))
	print()
	print(str(engine_force)+ "  " + str(brake))
	
	var air_res = linear_velocity.normalized()	 * air_resistance(speed, air_density, form_coefficent, surface)
	down_force = -global_transform.basis.y #Vector3(0,down_force_calc(speed, air_density, Cl, surface), 0)
	apply_central_force(down_force + air_res)
	dt += 1
	
	if SPEEDOMETER_LABEL:
		SPEEDOMETER_LABEL.text = str(int(linear_velocity.length()*3.6))

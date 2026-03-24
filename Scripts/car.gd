extends VehicleBody3D


@export var SPEEDOMETER_LABEL: Label

@onready var WheelFL = $VehicleWheelFL
@onready var WheelFR = $VehicleWheelFR
@onready var WheelRL = $VehicleWheelRL
@onready var WheelRR = $VehicleWheelRR
var wheel_list = [WheelFL, WheelFR, WheelRL, WheelRR]

@export var MAX_STEER = 0.5
@export var ENGINE_POWER = 50
@export var BRAKE_POWER = 10

var stearing_speed = 1.2
var returning_speed = 1.5
var max_steering

var direction = 1
var speed
var pedal_sens = 2

var brake_balance = 0.8

var air_density = 1.225
var form_coefficent = 1
var surface = 2

func air_resistance(spd, dens, form, surf):
	return (0.5 * dens *spd*spd*form*surf)
	

func _physics_process(delta):
	#max_steering = MAX_STEER
	
	WheelFL.suspension_stiffness = Global.suspension_stiffnessF
	WheelFR.suspension_stiffness = Global.suspension_stiffnessF
	WheelRL.suspension_stiffness = Global.suspension_stiffnessR
	WheelRR.suspension_stiffness = Global.suspension_stiffnessR
	
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
			
	if Input.is_action_pressed("ahead"):
		direction = 1
		
	if Input.is_action_pressed("reverse"):
		direction = -1
	
	speed = linear_velocity.length()
	engine_force = int(Input.is_action_pressed("up")) * ENGINE_POWER * direction
	
	
	WheelFL.brake = int(Input.is_action_pressed("down")) * BRAKE_POWER * brake_balance
	WheelFR.brake = int(Input.is_action_pressed("down")) * BRAKE_POWER * brake_balance
	WheelRL.brake = int(Input.is_action_pressed("down")) * BRAKE_POWER * (1-brake_balance)
	WheelRR.brake = int(Input.is_action_pressed("down")) * BRAKE_POWER * (1-brake_balance)
	#print("")
	#print(str(WheelFL.get_skidinfo()) + "\t" + str(WheelFR.get_skidinfo()))
	#print(str(WheelRL.get_skidinfo()) + "\t" + str(WheelRR.get_skidinfo()))
	#print()
	#print(str(engine_force)+ "  " + str(brake))
	
	var air_res = linear_velocity.normalized()	 * air_resistance(speed, air_density, form_coefficent, surface) *-1
	apply_central_force(air_res)
	
	if SPEEDOMETER_LABEL:
		SPEEDOMETER_LABEL.text = str(int(linear_velocity.length()*3.6))

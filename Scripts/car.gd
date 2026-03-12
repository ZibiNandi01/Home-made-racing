extends VehicleBody3D


@export var MAX_STEER = 0.4
var stearing_speed = 1
var returning_speed = 2
@export var ENGINE_POWER = 50
@export var BRAKE_POWER = 10
var direction = 1
@export var SPEEDOMETER_LABEL: Label
var speed
var air_density = 1.225
var form_coefficent = 1
var surface = 2

func air_resistance(spd, dens, form, surf):
	return (0.5 * dens *spd*spd*form*surf)

func _physics_process(delta):
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
	brake = int(Input.is_action_pressed("down")) * BRAKE_POWER
	
	var air_res = linear_velocity.normalized()	 * air_resistance(speed, air_density, form_coefficent, surface) *-1
	apply_central_force(air_res)
	
	if SPEEDOMETER_LABEL:
		SPEEDOMETER_LABEL.text = str(int(linear_velocity.length()*3.6))

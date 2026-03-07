extends VehicleBody3D


@export var MAX_STEER = 0.6
var stearing_speed = 1.25
var returning_speed = 2.5
@export var ENGINE_POWER = 5000
@export var BRAKE_POWER = 25
var direction = 1
@export var SPEEDOMETER_LABEL: Label

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
	
	engine_force = int(Input.is_action_pressed("up")) * ENGINE_POWER * direction
	brake = int(Input.is_action_pressed("down")) * BRAKE_POWER
	
	if SPEEDOMETER_LABEL:
		SPEEDOMETER_LABEL.text = str(int(linear_velocity.length()*3.6))

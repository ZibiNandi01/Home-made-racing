extends Node3D

@onready var car = $Car

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	car.reset_position.x = -329.49
	car.reset_position.y = 1.695 # Replace with function body.
	car.reset_position.z = -54.432

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

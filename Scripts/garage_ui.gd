extends VBoxContainer

@export var front_susp_stiff_label: Label
@export var front_susp_stiff: HSlider
@export var button_exit: Button

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	button_exit.text = "Main menu"
	button_exit.pressed.connect(_button_pressed_exit)
	front_susp_stiff.value = Global.suspension_stiffnessF
	
	 # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	Global.suspension_stiffnessF = front_susp_stiff.value
	front_susp_stiff_label.text = "Front suspension stiffness: " + str(front_susp_stiff.value)


func _button_pressed_exit():
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")

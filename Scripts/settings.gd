extends VBoxContainer

#@export var back_button: Button
@export var steering_label: Label
@export var steering_button: Button
@export var mainmenu: VBoxContainer
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	steering_label.text = "Steering type:"
	steering_button.pressed.connect(steering_changed)

# Called every frame. 'delta' is the elapsed time since the previous frame.

func _process(delta: float) -> void:
	steering_button.text = Global.steering_type

func steering_changed():
	if steering_button.text == "Button":
		Global.steering_type = "Slider"
		#steering_button.text = "Slider"
	elif steering_button.text == "Slider":
		Global.steering_type = "Button"

extends GridContainer

@export var back_button: Button
@export var steering_label: Label
@export var steering_button: Button
@export var mainmenu: VBoxContainer
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	back_button.text = "Back" # Replace with function body.
	back_button.pressed.connect(back_pressed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func back_pressed():
	$".".visible = false
	mainmenu.visible = true

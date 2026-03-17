extends VBoxContainer

func _ready():
	var button = Button.new()
	button.text = "Play"
	button.pressed.connect(_button_pressed)
	add_child(button)

func _button_pressed():
	print("Hello world!")
	get_tree().change_scene_to_file("res://Scenes/game.tscn")

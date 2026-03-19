extends VBoxContainer

func _ready():
	var button_play = Button.new()
	button_play.text = "Play"
	button_play.pressed.connect(_button_pressed_play)
	add_child(button_play)
	
	var button_user_manual =Button.new()
	button_user_manual.text = "User manual"
	button_user_manual.pressed.connect(_button_pressed_user_manual)
	add_child(button_user_manual)

func _button_pressed_play():
	get_tree().change_scene_to_file("res://Scenes/game.tscn")


func _button_pressed_user_manual():
	pass

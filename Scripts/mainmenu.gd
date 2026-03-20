extends VBoxContainer

@export var button_play: Button
@export var button_user_manual:Button
@export var label_user_manual: Label
@export var button_back: Button
	
func _ready():

	button_play.text = "Play"
	button_play.pressed.connect(_button_pressed_play)

	button_user_manual.text = "User manual"
	button_user_manual.pressed.connect(_button_pressed_user_manual)
	
	var text = FileAccess.open("res://User_manual.txt",FileAccess.READ)
	label_user_manual.text = text.get_as_text()

	button_back.text = "Back"
	button_back.pressed.connect(_button_pressed_back)


func _button_pressed_play():
	get_tree().change_scene_to_file("res://Scenes/game.tscn")


func _button_pressed_user_manual():
	$Play.visible = false
	$ButtonUserManual.visible = false
	$LabelUserManual.visible = true
	$Back.visible = true
	
func _button_pressed_back():
	$LabelUserManual.visible = false
	$Back.visible = false
	$Play.visible = true
	$ButtonUserManual.visible = true
	

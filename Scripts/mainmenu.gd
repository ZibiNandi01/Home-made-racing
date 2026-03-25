extends Control

@export var button_play: Button
@export var settings_button: Button
@export var button_user_manual: Button
@export var button_exit: Button
@export var label_user_manual: Label
@export var button_back: Button

@export var settings: GridContainer
@export var user_manual: VBoxContainer
@export var main_menu: VBoxContainer
@export var back: Button
	
func _ready():

	button_play.text = "Play"
	button_play.pressed.connect(_button_pressed_play)
	
	settings_button.text = "Settings"
	settings_button.pressed.connect(_button_pressed_settings)
	

	button_user_manual.text = "User manual"
	button_user_manual.pressed.connect(_button_pressed_user_manual)
	
	button_exit.text = "Exit"
	button_exit.pressed.connect(_button_pressed_exit)
	
	var text = FileAccess.open("res://User_manual.txt",FileAccess.READ)
	label_user_manual.text = text.get_as_text()

	button_back.text = "Back"
	button_back.pressed.connect(_button_pressed_back)


func _button_pressed_play():
	get_tree().change_scene_to_file("res://Scenes/game.tscn")

func _button_pressed_settings():
	main_menu.visible = false
	settings.visible = true
	back.visible = true

func _button_pressed_user_manual():
	main_menu.visible = false
	user_manual.visible = true
	back.visible = true
	
func _button_pressed_back():
	user_manual.visible = false
	settings.visible = false
	main_menu.visible = true
	back.visible = false
	
func _button_pressed_exit():
	get_tree().quit()
	


func _process(delta: float) -> void:
	pass

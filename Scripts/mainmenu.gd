extends Control

@export var button_play: Button
@export var settings_button: Button
@export var button_user_manual: Button
@export var button_exit: Button
@export var label_user_manual: Label
@export var button_back: Button

@export var settings: TabContainer
@export var user_manual: VBoxContainer
@export var main_menu: VBoxContainer
@onready var play = $Play
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
	main_menu.visible = false
	play.visible = true
	

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
	play.visible = false
	main_menu.visible = true
	back.visible = false
	
func _button_pressed_exit():
	get_tree().quit()
	


func _process(delta: float) -> void:
	pass


func _on_test_track_pressed() -> void:
	Global.track = 0
	get_tree().change_scene_to_file("res://Scenes/test_track_logik.tscn") # Replace with function body.


func _on_server_pressed() -> void:
	NetworHandler.start_server()
	get_tree().change_scene_to_file("res://Scenes/test_track_logik.tscn") # Replace with function body.


func _on_client_pressed() -> void:
	NetworHandler.start_client()	
	get_tree().change_scene_to_file("res://Scenes/test_track_logik.tscn") # Replace with function body.

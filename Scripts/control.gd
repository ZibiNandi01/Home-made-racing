extends VBoxContainer

@onready var steering_menu: OptionButton = $Steering/Steering
var on_start_steer

@onready var gearbox_container = $GearBox
@onready var gearbox_menu: OptionButton = $GearBox/GearBox
var on_start_gear_box


var steering_types = ["Button", "Slider"]
var gear_box_types = ["manual", "automatic"]
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(len(steering_types)):
		steering_menu.add_item(steering_types[i]) # Replace with function body.
	for i in range(len(steering_types)):
		if steering_types[i] == Global.steering_type:
			on_start_steer = i
	steering_menu.select(on_start_steer)
	
	for i in range(len(gear_box_types)):
		gearbox_menu.add_item(gear_box_types[i]) # Replace with function body.
	for i in range(len(gear_box_types)):
		if gear_box_types[i] == Global.gear_box_type:
			on_start_gear_box = i
	steering_menu.select(on_start_gear_box)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var steer_id = steering_menu.get_selected_id()
	Global.steering_type = steering_menu.get_item_text(steer_id)
	var gear_box_id = gearbox_menu.get_selected_id()
	Global.gear_box_type = gearbox_menu.get_item_text(gear_box_id)
	
	if Global.steering_type == "Slider":
		gearbox_container.visible = false
	else:
		gearbox_container.visible = true

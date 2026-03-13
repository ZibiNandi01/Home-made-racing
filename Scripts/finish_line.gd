extends Area3D

@export var CURRENT_TIME_LABEL: Label
@export var FASTEST_TIME_LABEL: Label
@export var LAST_LAP: Label

var lap_stert_time=0
var lap_time=0
var current_time

var fastest_time = 500000000

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_process(true) # Replace with function body.


func _on_body_entered(body: Node3D) -> void:
	if lap_stert_time!=0:
		lap_time = float(Time.get_ticks_msec() - lap_stert_time)/1000
		#print(Time.get_ticks_msec())
		if lap_time < fastest_time:
			fastest_time = float(lap_time)
		#print("finish: ", lap_time)
	lap_stert_time = Time.get_ticks_msec()
	#print(lap_stert_time)
	
	
	
func _process(delta: float) -> void:
	if CURRENT_TIME_LABEL:
		if lap_stert_time != 0:
			current_time = float(Time.get_ticks_msec() - lap_stert_time) / 1000
			CURRENT_TIME_LABEL.text = str("Current lap: " + str(current_time))
		else:
			CURRENT_TIME_LABEL.text = str("Current lap: ")
	
	if LAST_LAP:
		if lap_time != 0:
			LAST_LAP.text = "Last lap: "+ str(lap_time)
		else:
			LAST_LAP.text = str("Last lap: ")
	
	if FASTEST_TIME_LABEL:
		if fastest_time != 500000000:
			FASTEST_TIME_LABEL.text = "Fastest lap: " + str(fastest_time)
		else:
			FASTEST_TIME_LABEL.text = str("Fastest lap: ")

extends Area3D

@export var CURRENT_TIME_LABEL: Label
@export var FASTEST_TIME_LABEL: Label
@export var LAST_LAP: Label

var lap_stert_time=0
var last_lap=0
var current_time
var current_time_minute
#var last_lap_minute
var fastest_lap_minute

var fastest_time = 500000000

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_process(true)
	CURRENT_TIME_LABEL.text = ""
	FASTEST_TIME_LABEL.text = ""
	LAST_LAP.text = ""


func _on_body_entered(body: Node3D) -> void:
	if lap_stert_time!=0:
		last_lap = float(Time.get_ticks_msec() - lap_stert_time)/1000 + 50
		#print(Time.get_ticks_msec())
		if last_lap < fastest_time:
			fastest_time = float(last_lap)
		#print("finish: ", last_lap)
	lap_stert_time = Time.get_ticks_msec()
	#print(lap_stert_time)
	
	
	
func _process(delta: float) -> void:
	if CURRENT_TIME_LABEL:
		if lap_stert_time != 0:
			current_time_minute = 0
			
			fastest_time = float(last_lap)
		#print("finish: ", last_lap)
			current_time = float(Time.get_ticks_msec() - lap_stert_time) / 1000
			while current_time >= 60:
				current_time_minute += 1
				current_time -= 60
			CURRENT_TIME_LABEL.text = str("Current lap: " + str(current_time_minute) + ":" + str(current_time))
		else:
			CURRENT_TIME_LABEL.text = str("Current lap: ")
	
	if LAST_LAP:
		var last_lap_minute = 0
		if last_lap != 0:
			while last_lap >= 60:
				last_lap_minute += 1
				last_lap -= 60
				print(last_lap_minute)
			LAST_LAP.text = str("Last lap: " + str(int(last_lap_minute)) + ":" + str(last_lap))
		else:
			LAST_LAP.text = str("Last lap: ")
	
	if FASTEST_TIME_LABEL:
		if fastest_time != 500000000:
			FASTEST_TIME_LABEL.text = "Fastest lap: " + str(fastest_time)
		else:
			FASTEST_TIME_LABEL.text = str("Fastest lap: ")

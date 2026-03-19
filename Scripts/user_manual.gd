extends VBoxContainer


# Called when the node enters the scene tree for the first time.
func _ready():
	var label_user_manual = Label.new()
	var text = FileAccess.open("res://User_manual.txt",FileAccess.READ)
	label_user_manual.text = text.get_as_text()
	add_child(label_user_manual)



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

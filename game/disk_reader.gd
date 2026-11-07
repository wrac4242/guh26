extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _handleFloppyDiskChange(state: String) -> void:
	print(state)
	pass

var validStates = ["Not Present", "Forest", "Mountain", "Foundry"]
var currentState = "Not Present"

func _on_timer_timeout() -> void:
	if (!FileAccess.file_exists("FloppyTest.txt")):
		pass
	var file = FileAccess.open("FloppyTest.txt", FileAccess.READ)
	var content = file.get_as_text()
	if (currentState == content):
		pass
	else:
		currentState = content
		_handleFloppyDiskChange(currentState);
	
	pass # Replace with function body.

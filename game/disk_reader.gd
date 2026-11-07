extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

var validStates = ["Not Present", "Forest", "Mountain", "Foundry"]
var currentState = "Not Present"

func _on_timer_timeout() -> void:
	var file = FileAccess.open("C:\\Users\\laure\\FloppyTest.txt", FileAccess.READ)
	var content = file.get_as_text()
	print(content)
	
	pass # Replace with function body.

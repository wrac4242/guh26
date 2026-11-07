extends Node
signal island_changed(new_state: String)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	island_changed.emit("Not Present")
	_on_timer_timeout()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _handleFloppyDiskChange(state: String) -> void:
	island_changed.emit(state)
	print(state)
	if state == "Not Present":
		_teleport_player_to_center()
	pass

func _teleport_player_to_center() -> void:
	var player := get_tree().get_first_node_in_group("player")
	var spawn := get_tree().get_first_node_in_group("center_spawn") as Node2D
	if player == null:
		push_error("Cannot teleport after floppy disk removal: no player was found.")
		return
	if spawn == null:
		push_error("Cannot teleport after floppy disk removal: no center spawn was found.")
		return
	if not player.has_method("teleport_to"):
		push_error("Cannot teleport after floppy disk removal: the player has no teleport_to method.")
		return

	player.call("teleport_to", spawn.global_position)

var validStates = ["Not Present", "Forest", "Mountain", "Foundry"]
var currentState = "Not Present"

func _on_timer_timeout() -> void:
	var content = "Not Present"
	if FileAccess.file_exists("FloppyTest.txt"):
		content = FileAccess.get_file_as_string("FloppyTest.txt").strip_edges()
	if not validStates.has(content):
		return
	if currentState != content:
		currentState = content
		_handleFloppyDiskChange(currentState)
	
	pass # Replace with function body.

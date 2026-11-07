extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	WorldState.resources_changed.connect(update_resources)
	DiskReader.island_changed.connect(update_floppy)
	update_resources()
	update_floppy("Not Present")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func update_resources() -> void:
	var wood = WorldState.get_resource_amount("wood")
	var metal = WorldState.get_resource_amount("metal")
	var bricks = WorldState.get_resource_amount("brick")
	var template = "Wood: %s\nMetal: %s\nBricks: %s"
	var to_show = template % [wood, metal, bricks]
	$Resources.text = to_show
	$Resources.show()
	pass

func update_floppy(area: String) -> void:
	$Floppy.text = area 
	$Floppy.show()
	pass

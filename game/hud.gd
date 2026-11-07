extends CanvasLayer

var wood_upgrade = 1
var metal_upgrade = 1
var rock_upgrade = 1



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
	
func rupgrade() -> void:
	print(WorldState.get_resource_amount("metal"))
	if WorldState.get_resource_amount("metal") < 10*  rock_upgrade:
		return
	WorldState.remove_resource("metal", 10*rock_upgrade)
	rock_upgrade += 1
	$RockUpgrade.text = "Rock Upgrade: %s (%s Metal)" % [ rock_upgrade, rock_upgrade * 10 ]
	$RockUpgrade.show()


func wupgrade() -> void:
	print(WorldState.get_resource_amount("rock"))
	if WorldState.get_resource_amount("rock") < 10*  wood_upgrade:
		return
	WorldState.remove_resource("rock", 10*wood_upgrade)
	wood_upgrade += 1
	$RockUpgrade.text = "Wood Upgrade: %s (%s Rock)" % [ wood_upgrade, wood_upgrade * 10 ]
	$RockUpgrade.show()
	
func mupgrade() -> void:
	print(WorldState.get_resource_amount("wood"))
	if WorldState.get_resource_amount("wood") < 10*  metal_upgrade:
		return
	WorldState.remove_resource("wood", 10*metal_upgrade)
	metal_upgrade += 1
	$RockUpgrade.text = "Metal Upgrade: %s (%s Wood)" % [ metal_upgrade, metal_upgrade * 10 ]
	$RockUpgrade.show()

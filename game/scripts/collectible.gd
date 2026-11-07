extends Area2D

@export_enum("wood", "brick", "metal")
var resource_type: String = "wood"

@onready var sprite: Sprite2D = $Sprite2D
@export var forest_texture: Texture2D
@export var mountain_texture: Texture2D
@export var foundry_texture: Texture2D

@export var floppy_disk: Node
@export var amount: int = 1

func _ready() -> void:
	DiskReader.connect("island_changed", _on_island_changed)
	_on_island_changed(DiskReader.get("currentState"))
	
func _on_island_changed(new_state: String) -> void:
	match new_state:
		"Forest":
			sprite.texture = forest_texture
			resource_type = "wood"
		"Mountain":
			sprite.texture = mountain_texture
			resource_type = "brick"
		"Foundry":
			sprite.texture = foundry_texture
			resource_type = "metal"

	sprite.visible = new_state != "Not Present"

func _on_body_entered(body: Node2D) -> void:
	if not body.is_in_group("player"):
		return

	WorldState.add_resource(resource_type, amount)
	print("collected ", amount, " ", resource_type)

	var spawn := get_tree().get_first_node_in_group("center_spawn")
	if spawn:
		body.teleport_to(spawn.global_position)

	queue_free()

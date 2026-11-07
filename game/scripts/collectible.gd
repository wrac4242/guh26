extends Area2D

@export_enum("wood", "brick", "metal")
var resource_type: String = "wood"

@onready var sprite: Sprite2D = $Sprite2D
@export var forest_texture: Texture2D
@export var mountain_texture: Texture2D
@export var foundry_texture: Texture2D

@export var amount: int = 1

func _ready() -> void:
	match resource_type:
		"wood":
			sprite.texture = forest_texture
		"brick":
			sprite.texture = mountain_texture
		"metal":
			sprite.texture = foundry_texture

func _on_body_entered(body: Node2D) -> void:
	if is_queued_for_deletion() or not body.is_in_group("player"):
		return

	queue_free()
	WorldState.add_resource(resource_type, amount)
	print("collected ", amount, " ", resource_type)

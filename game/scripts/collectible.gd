extends Area2D

@export_enum("wood", "brick", "metal")
var resource_type: String = "wood"

@export var amount: int = 1

func _on_body_entered(body: Node2D) -> void:
	if not body.is_in_group("player"):
		return

	WorldState.add_resource(resource_type, amount)
	print("collected ", amount, " ", resource_type)

	queue_free()

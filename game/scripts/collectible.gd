extends Area2D

@export_enum("wood", "brick", "metal")
var resource_type: String = "wood"

@export var amount: int = 1

func _on_body_entered(body: Node2D) -> void:
	if not body.is_in_group("player"):
		return

	WorldState.add_resource(resource_type, amount)
	print("collected ", amount, " ", resource_type)

	var spawn := get_tree().get_first_node_in_group("center_spawn")
	if spawn:
		body.teleport_to(spawn.global_position)

	queue_free()

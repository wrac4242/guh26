extends Node

signal resources_changed

var resources := {
	"wood": 100,
	"brick": 50,
	"metal": 25
}

var money: float = 1000.0

func get_resource_amount(resource: String) -> int:
	return int(resources.get(resource, 0))

func add_resource(resource: String, amount: int) -> void:
	if amount <= 0 or not resources.has(resource):
		return

	resources[resource] += amount
	resources_changed.emit()

func remove_resource(resource: String, amount: int) -> bool:
	if amount <= 0 or not resources.has(resource):
		return false

	if resources[resource] < amount:
		return false

	resources[resource] -= amount
	resources_changed.emit()
	return true

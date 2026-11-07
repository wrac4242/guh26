
extends Node

signal upgrades_changed

var selected_path: String = ""
var unlocked_upgrades: Array[UpgradeData] = []

func purchase_upgrade(upgrade: UpgradeData) -> bool:
	# if we have one then dont bother buying again
	if unlocked_upgrades.has(upgrade):
		return false

	# locked into a different upgrade path?
	if selected_path != "" and selected_path != upgrade.path:
		return false

	# check whether we can afford it
	if WorldState.get_resource_amount("wood") < upgrade.wood_cost:
		return false

	if WorldState.get_resource_amount("brick") < upgrade.brick_cost:
		return false

	if WorldState.get_resource_amount("metal") < upgrade.metal_cost:
		return false

	# deduct resources
	if upgrade.wood_cost > 0:
		WorldState.remove_resource("wood", upgrade.wood_cost)

	if upgrade.brick_cost > 0:
		WorldState.remove_resource("brick", upgrade.brick_cost)

	if upgrade.metal_cost > 0:
		WorldState.remove_resource("metal", upgrade.metal_cost)

	# lock the player into this path
	selected_path = upgrade.path
	unlocked_upgrades.append(upgrade)

	upgrades_changed.emit()
	return true

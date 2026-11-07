extends Node2D

const COLLECTIBLE_SCENE := preload("res://collectible.tscn")
const ISLAND_TILE_TAGS := {"forest": "wood", "mountain": "stone", "foundry": "metal"}

@export var ground: TileMap
@export var pickup_count: int = 15
@export_range(0.1, 60.0, 0.1, "or_greater") var respawn_interval: float = 3.0

var candidates: Array[Vector2i] = []
var resource_type: String

func _ready() -> void:
	DiskReader.island_changed.connect(_spawn_for_island)
	_spawn_for_island(DiskReader.currentState)

	# Keep the timer out of the pickup list returned by get_children().
	var respawn_timer := Timer.new()
	add_child(respawn_timer, false, Node.INTERNAL_MODE_BACK)
	respawn_timer.timeout.connect(_fill_pickups)
	respawn_timer.start(respawn_interval)

func _spawn_for_island(island: String) -> void:
	for pickup in get_children():
		pickup.queue_free()
	candidates.clear()

	var island_key := island.strip_edges().to_lower()
	var tile_tag: String = ISLAND_TILE_TAGS.get(island_key, "")
	if tile_tag.is_empty():
		return
	resource_type = "brick" if tile_tag == "stone" else tile_tag

	var tag_layer := -1
	for layer in range(ground.tile_set.get_custom_data_layers_count()):
		if ground.tile_set.get_custom_data_layer_name(layer).nocasecmp_to("type") == 0:
			tag_layer = layer
			break
	if tag_layer == -1:
		return

	for cell in ground.get_used_cells(0):
		var tile := ground.get_cell_tile_data(0, cell)
		if tile != null and str(tile.get_custom_data_by_layer_id(tag_layer)).strip_edges().to_lower() == tile_tag:
			candidates.append(cell)
	_fill_pickups()

func _fill_pickups() -> void:
	if candidates.is_empty():
		return

	var occupied := {}
	for pickup: Node2D in get_children():
		if not pickup.is_queued_for_deletion():
			var cell := ground.local_to_map(ground.to_local(pickup.global_position))
			occupied[cell] = true

	var missing := mini(pickup_count, candidates.size()) - occupied.size()
	if missing <= 0:
		return

	var available := candidates.filter(func(cell: Vector2i) -> bool: return not occupied.has(cell))
	available.shuffle()
	for index in range(missing):
		var pickup := COLLECTIBLE_SCENE.instantiate() as Area2D
		pickup.resource_type = resource_type
		pickup.scale = Vector2(0.5, 0.5)
		pickup.position = to_local(ground.to_global(ground.map_to_local(available[index])))
		add_child(pickup)

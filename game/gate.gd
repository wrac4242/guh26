extends StaticBody2D

@export_enum("Forest", "Mountain", "Foundry") var opens_for: String = "Forest"

const CLOSED_TEXTURE = preload("res://Assets/kenney_roguelike-rpg-pack/fences/gate_closed.png")
const OPEN_TEXTURE = preload("res://Assets/kenney_roguelike-rpg-pack/fences/gate_open.png")

@onready var sprite: Sprite2D = $Sprite2D
@onready var collision: CollisionShape2D = $CollisionShape2D

func _ready() -> void:
	DiskReader.island_changed.connect(_on_island_changed)
	
	_on_island_changed(DiskReader.currentState)
	
	pass
	
func _on_island_changed(new_state: String) -> void:
	set_open(new_state == opens_for)

func set_open(is_open: bool) -> void:
	# deferred so the physics engine isn't changed mid-step.
	collision.set_deferred("disabled", is_open)
	sprite.texture = OPEN_TEXTURE if is_open else CLOSED_TEXTURE

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

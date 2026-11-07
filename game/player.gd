extends CharacterBody2D

@export var speed: float = 200.0

var current_interactable: Interactable = null


func _physics_process(_delta: float) -> void:
	var direction := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = direction * speed
	move_and_slide()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") and current_interactable:
		current_interactable.interact()

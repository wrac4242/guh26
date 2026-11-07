class_name Interactable
extends Area2D

@onready var prompt: Label = $PromptLabel

func _ready() -> void:
	prompt.visible = false
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		body.current_interactable = self
		prompt.visible = true

func _on_body_exited(body: Node) -> void:
	if body.is_in_group("player"):
		if body.current_interactable == self:
			body.current_interactable = null
		prompt.visible = false

func interact() -> void:
	print("Interacted with ", name)

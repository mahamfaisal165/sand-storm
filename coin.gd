extends Area2D

@onready var game_manager: Node = %"game manager"

# Optional: Adjust point value in the Inspector
@export var score_value: int = 1

func _ready() -> void:
	# Connect the body_entered signal automatically
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	# Check if the colliding body is the player
	if body.is_in_group("player") or body.name.to_lower().contains("player"):
		game_manager.add_point()
		queue_free()

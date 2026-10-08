extends Area2D

# Optional: Adjust point value in the Inspector
@export var score_value: int = 1

func _ready() -> void:
	# Connect the body_entered signal automatically
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	# Check if the colliding body is the player
	if body.is_in_group("player") or body.name.to_lower().contains("player"):
		# Add score logic here if you have a Global/Game Manager, e.g.:
		# GameManager.add_score(score_value)
		
		# Remove the coin from the scene
		queue_free()

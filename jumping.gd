extends Area2D

@export var bounce_velocity: float = -800.0  # Adjust for higher/lower bounce

func _ready():
	# Connect the signal when a physics body enters this Area2D
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	# Check if the colliding object is the player (uses CharacterBody2D)
	if body is CharacterBody2D:
		# Directly push the player upwards
		body.velocity.y = bounce_velocity

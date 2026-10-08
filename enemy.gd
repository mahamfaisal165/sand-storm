extends CharacterBody2D

@export var health: int = 5

var previous_x: float = 0.0

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var hitbox: Area2D = $Hitbox


func _ready() -> void:
	# Record initial x position
	previous_x = global_position.x
	
	# Connect the Hitbox's body_entered signal automatically
	hitbox.body_entered.connect(_on_hitbox_body_entered)


func _physics_process(_delta: float) -> void:
	# Flip sprite based on horizontal movement
	if global_position.x > previous_x:
		sprite.flip_h = true
	elif global_position.x < previous_x:
		sprite.flip_h = false

	# Update previous position
	previous_x = global_position.x

	# Execute physics movement
	move_and_slide()


func _on_hitbox_body_entered(body: Node2D) -> void:
	# Reload scene instantly when colliding with player
	if body.is_in_group("player"):
		get_tree().reload_current_scene()


# Call this function when the player's weapon hits the enemy
func take_damage(amount: int) -> void:
	health -= amount
	print("Enemy hit! Remaining health: ", health)

	if health <= 0:
		die()


func die() -> void:
	queue_free()

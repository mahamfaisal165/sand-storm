extends Area2D

@export var speed: float = 600.0

var direction: Vector2 = Vector2.RIGHT

func _ready() -> void:
	# Automatically delete bullet after 3 seconds if it misses everything
	get_tree().create_timer(3.0).timeout.connect(func(): call_deferred("queue_free"))

func _physics_process(delta: float) -> void:
	# Move in the aiming direction
	position += direction * speed * delta

# Sets the direction and rotates the bullet sprite towards the mouse
func set_direction(target_dir: Vector2) -> void:
	direction = target_dir.normalized()
	rotation = direction.angle()

# Use area_entered because the enemy's hitbox is an Area2D
func _on_area_entered(area: Area2D) -> void:
	var enemy = area.owner # Gets the parent CharacterBody2D of the enemy
	
	if enemy and enemy.is_in_group("player"):
		return
		
	if enemy and (enemy.is_in_group("enemy") or enemy.has_method("take_damage")):
		enemy.take_damage(1)
		call_deferred("queue_free")
	elif area.is_in_group("enemy") or area.has_method("take_damage"):
		area.take_damage(1)
		call_deferred("queue_free")

# Keep body_entered just in case it hits a wall/TileMap
func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		return
		
	if body is TileMap or body is TileMapLayer:
		call_deferred("queue_free")

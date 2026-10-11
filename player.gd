extends CharacterBody2D

const SPEED = 200.0
const JUMP_VELOCITY = -300.0
@export var bullet_scene: PackedScene = preload("res://bullet.tscn")
# Reference to the AnimatedSprite2D child node
@onready var animated_sprite = $AnimatedSprite2D

func _physics_process(delta):
	# Add gravity if the character is in the air
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump input
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get horizontal movement direction (-1 for left, 1 for right, 0 for idle)
	var direction = Input.get_axis("left", "right")
	
	if direction != 0:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	# Update animations based on movement and state
	update_animation(direction)

	move_and_slide()

func update_animation(direction):
	if not is_on_floor():
		animated_sprite.play("jump")
	elif direction < 0:
		animated_sprite.play("left")
	elif direction > 0:
		animated_sprite.play("right")
	else:
		animated_sprite.play("idle")


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("throw"):
		shoot_bullet()

func shoot_bullet() -> void:
	if bullet_scene == null:
		print("Error: Bullet scene is missing!")
		return

	# 1. Spawn bullet
	var bullet = bullet_scene.instantiate()
	get_tree().current_scene.add_child(bullet)
	
	# 2. Spawn at player's position
	bullet.global_position = global_position
	
	# 3. Calculate direction towards mouse click
	var mouse_pos = get_global_mouse_position()
	var shoot_direction = (mouse_pos - global_position).normalized()
	
	# 4. Pass aiming direction to bullet
	bullet.set_direction(shoot_direction)

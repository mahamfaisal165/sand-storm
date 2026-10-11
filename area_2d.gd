extends Area2D

@export var orbit_speed: float = 3.0 # Speed of circling around tornado center
@export var self_spin_speed: float = 10.0 # Speed of rotation on player's own axis
@export var orbit_radius: float = 30.0 # Distance from tornado center while trapped

var trapped_player: CharacterBody2D = null
var jump_count: int = 0
var angle: float = 0.0

func _ready() -> void:
	# Automatically connect to body_entered signal
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	# Matches your exact group name "player"
	if body.is_in_group("player") and trapped_player == null:
		trapped_player = body
		jump_count = 0
		angle = 0.0
		
		# Prevent the player's standard script physics movement while trapped
		trapped_player.set_physics_process(false)

func _physics_process(delta: float) -> void:
	if trapped_player != null:
		# 1. Spin the player sprite around
		trapped_player.rotation += self_spin_speed * delta
		
		# 2. Orbit the player around the center of the tornado
		angle += orbit_speed * delta
		var offset = Vector2(cos(angle), sin(angle)) * orbit_radius
		trapped_player.global_position = global_position + offset
		
		# 3. Check for jump press (uses default Space/Enter or custom jump action)
		if Input.is_action_just_pressed("ui_accept"): 
			jump_count += 1
			print("Jumps: ", jump_count, "/2")
			
			if jump_count >= 2:
				release_player()

func release_player() -> void:
	if trapped_player != null:
		# Reset rotation and give player control back
		trapped_player.rotation = 0.0
		trapped_player.set_physics_process(true)
		
		print("Player escaped the tornado!")
		trapped_player = null
		jump_count = 0

extends Area2D

@export_file("*.tscn") var target_scene: String

@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var is_activated: bool = false

func _on_body_entered(body: Node2D) -> void:
	if is_activated:
		return
		
	# Ignore floor/tiles
	if body is TileMap or body is TileMapLayer:
		return

	# 1. Check if the player is entering
	if body.is_in_group("player") or body.name.to_lower() == "player":
		
		# 2. Check if there are still coins/bottles left
		var remaining_coins = get_tree().get_nodes_in_group("coin").size()
		if remaining_coins > 0:
			print("Collect all items first! Remaining: ", remaining_coins)
			return # Portal stays locked!

		is_activated = true
		
		# Play open animation
		if animated_sprite_2d:
			animated_sprite_2d.play("open")
		
		# Play sound effect without waiting
		if audio_stream_player_2d and audio_stream_player_2d.stream:
			audio_stream_player_2d.play()
		
		# Instantly change scene
		if target_scene != "":
			get_tree().change_scene_to_file(target_scene)
		else:
			print("Error: Target scene is not selected in the Inspector!")

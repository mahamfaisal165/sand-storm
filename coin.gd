extends Area2D

@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var game_manager: Node = %"game manager"

@export var score_value: int = 1

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") or body.name.to_lower() == "player":
		game_manager.add_point()
		
		# 1. Hide sprite and disable collision so player can't double-collect
		$AnimatedSprite2D.visible = false
		$CollisionShape2D.set_deferred("disabled", true)
		
		# 2. Play the sound and wait for it to finish before deleting the coin
		if audio_stream_player_2d and audio_stream_player_2d.stream:
			audio_stream_player_2d.play()
			await audio_stream_player_2d.finished
			
		# 3. Now safely remove the coin
		queue_free()

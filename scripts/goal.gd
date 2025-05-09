extends Area2D


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		GameManager.player_won.emit()
		$AudioStreamPlayer.playing = true
		$AnimatedSprite2D.play("activated")
		$CPUParticles2D.emitting = true
		$CPUParticles2D2.emitting = true
		$CPUParticles2D3.emitting = true
		$CPUParticles2D4.emitting = true
		$CPUParticles2D5.emitting = true
		$Timer.start()


func _on_timer_timeout() -> void:
	Transition.change_scene("res://scenes/main_menu.tscn")

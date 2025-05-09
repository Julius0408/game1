extends Area2D


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		$AudioStreamPlayer.playing = true
		$CollisionShape2D.set_deferred("disabled", true)
		$AnimatedSprite2D.play("disappear")
		await $AnimatedSprite2D.animation_finished
		queue_free()

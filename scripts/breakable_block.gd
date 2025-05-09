extends StaticBody2D

func _on_hitbox_body_entered(body: Node2D) -> void:
	if body is Player:
		$AudioStreamPlayer.playing = true
		$CollisionShape2D.set_deferred("disabled", true)
		$Hitbox/HitboxCollider.set_deferred("disabled", true)
		$AnimatedSprite2D.play("hit")
		await $AnimatedSprite2D.animation_finished
		$AnimatedSprite2D.play("break")
		await $AnimatedSprite2D.animation_finished
		queue_free()

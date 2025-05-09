extends StaticBody2D

var activated = false

func _on_hitbox_body_entered(body: Node2D) -> void:
	if activated:
		if body.has_method("die"):
			body.call_deferred("die")

	else:
		if body is Player:
			$ActivationTimer.start()
			$AnimatedSprite2D.play("activate")
			await $AnimatedSprite2D.animation_finished
			$AnimatedSprite2D.play("on")


func _on_activation_timer_timeout() -> void:
	activated = true
	for body in $Hitbox.get_overlapping_bodies():
		if body.has_method("die"):
			body.call_deferred("die")

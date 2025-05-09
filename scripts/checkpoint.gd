extends Area2D
signal activated(position: Vector2)

var is_activated = false

func _on_body_entered(body: Node2D) -> void:
	if body is Player and not is_activated:
		activate(false)
		
func activate(by_system=true) -> void:
	is_activated = true
	emit_signal("activated", global_position)
	if not by_system:
		$AnimatedSprite2D.play("activation")
		await $AnimatedSprite2D.animation_finished
	$AnimatedSprite2D.play("active")

extends Area2D

var velocity = Vector2.ZERO

func _process(delta):
	position += velocity * delta


func _on_visible_on_screen_enabler_2d_screen_exited() -> void:
	queue_free()


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		body.die()
	else:
		queue_free()

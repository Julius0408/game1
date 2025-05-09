extends Area2D



func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		body.call_deferred("die")
	elif body is CharacterBody2D and body.has_method("die"):
		body.call_deferred("die")

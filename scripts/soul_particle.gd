extends Area2D
signal life_removed

@export var boss = null


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		life_removed.emit()
		queue_free()
		
func _on_lifetime_timeout() -> void:
	$CollisionShape2D.disabled = true
	$AnimatedSprite2D.play("disappear")
	await $AnimatedSprite2D.animation_finished
	queue_free()

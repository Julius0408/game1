extends PathFollow2D

@export var speed: float = 0.3

func _physics_process(delta: float) -> void:
	progress_ratio += delta * speed
	


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		body.call_deferred("die")
	elif body is CharacterBody2D and body.has_method("die"):
		body.call_deferred("die")

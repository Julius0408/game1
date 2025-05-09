extends Area2D

@export var target_position: Marker2D


func _on_body_entered(body):
	if body is  Player:
		body.global_position = target_position.global_position

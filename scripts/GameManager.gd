extends Node

signal player_won
signal pause
signal resume

var checkpoint_pos: Vector2

func _ready() -> void:
	connect("player_won", reset_checkpoint_pos)

func set_checkpoint_pos(pos: Vector2) -> void:
	checkpoint_pos = pos
	
func get_checkpoint_pos() -> Vector2:
	return checkpoint_pos
	
func reset_checkpoint_pos() -> void:
	checkpoint_pos = Vector2.ZERO

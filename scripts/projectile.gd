extends Area2D


var dir: int
var spawnPos: Vector2
var speed: int

func _ready() -> void:
	global_position = spawnPos
	
func _physics_process(delta: float) -> void:
	if not $AnimatedSprite2D.animation == "destruction":
		global_position.x -= delta * speed * dir
	


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		body.call_deferred("die")
	elif body is CharacterBody2D and body.has_method("die"):
		body.call_deferred("die")
	$AnimatedSprite2D.play("destruction")
	await $AnimatedSprite2D.animation_finished
	queue_free()
		

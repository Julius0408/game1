extends StaticBody2D

@onready var main = get_parent().get_parent()
@onready var projectile = preload("res://scenes/projectile.tscn")

@export var shooting_dir: int = 1
@export var speed: int = 80
@export var cooldown_time: int = 2

func _ready() -> void:
	$Cooldown.wait_time = cooldown_time

func shoot() -> void:
	$AnimatedSprite2D.play("shoot")
	await $AnimatedSprite2D.animation_finished
	var instance = projectile.instantiate()
	instance.dir = shooting_dir
	instance.speed = speed

	instance.spawnPos = $ExitPos.global_position
	main.add_child.call_deferred(instance)
	$AnimatedSprite2D.play("idle")

func _on_cooldown_timeout() -> void:
	shoot()

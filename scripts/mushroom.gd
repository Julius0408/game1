extends CharacterBody2D

var speed = 50 
var direction = -1
var gravity = 800

@export var bounce_force: float = -200.0

@onready var sprite = $AnimatedSprite2D
@onready var edge_check_left = $EdgeCheckLeft
@onready var edge_check_right = $EdgeCheckRight
@onready var hitbox = $Hitbox

var is_dead = false

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta

	if is_on_wall() or not edge_check_left.is_colliding() or not edge_check_right.is_colliding():
		direction *= -1
		sprite.flip_h = not sprite.flip_h
		
	if not is_dead:
		velocity.x = speed * direction
	else:
		velocity.x = 0
	
	
	move_and_slide()


func _on_hitbox_body_entered(body: Node2D) -> void:
	if body is Player:
		if body.global_position.y + 5 < global_position.y:
			call_deferred("die")
			body.velocity.y = bounce_force
		else:
			body.call_deferred("die")

			
func die():
	if not is_dead:
		$AudioStreamPlayer.playing = true
		is_dead = true
		hitbox.call_deferred("queue_free")
		$AnimatedSprite2D.play("die")
		await $AnimatedSprite2D.animation_finished
		queue_free()
	

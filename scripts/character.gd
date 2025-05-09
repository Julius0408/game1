extends CharacterBody2D
class_name Player

enum State {
	IDLE,
	RUNNING,
	JUMPING,
	FALLING,
	DEAD,
}


var state = State.IDLE

var speed = 180.0
var acceleration = 30.0
var platform_velocity = Vector2.ZERO
var jump_force = -400
var gravity = 800
var max_fall_speed = 600

var COYOTE_TIME = 0.2
var coyote_timer = 0.0

var jump_buffer_time = 0.2
var jump_buffer_timer = 0.0

var jump_cut_multiplier = 2.0

var air_friction = 5.0

var disabled = false

@onready var animated_sprite = $AnimatedSprite2D

func _ready() -> void:
	GameManager.player_won.connect(disable)

func _physics_process(delta):
	if not state == State.DEAD:
		if is_on_floor():
			coyote_timer = COYOTE_TIME
		else:
			coyote_timer = max(0, coyote_timer - delta)
		
		
		if is_on_floor() and state != State.JUMPING and state != State.FALLING:
			velocity.y = 0
		else:
			velocity.y += gravity * delta
			if velocity.y > max_fall_speed:
				velocity.y = max_fall_speed
		
		if not disabled:
			if state == State.JUMPING and not Input.is_action_pressed("jump") and velocity.y < 0:
				velocity.y += gravity * (jump_cut_multiplier - 1) * delta
			
			if is_on_floor():
				if Input.is_action_pressed("ui_left"):
					velocity.x -= acceleration
					if velocity.x < -speed:
						velocity.x = -speed
				elif Input.is_action_pressed("ui_right"):
					velocity.x += acceleration
					if velocity.x > speed:
						velocity.x = speed
				else:
					velocity.x = 0.0
			else:
				if Input.is_action_pressed("ui_left"):
					velocity.x -= acceleration
					if velocity.x < -speed:
						velocity.x = -speed
				elif Input.is_action_pressed("ui_right"):
					velocity.x += acceleration
					if velocity.x > speed:
						velocity.x = speed
				else:
					velocity.x = lerp(velocity.x, 0.0, air_friction * delta)
					
			if Input.is_action_just_pressed("jump"):
					jump_buffer_timer = jump_buffer_time
					
			if jump_buffer_timer > 0 and (is_on_floor() or coyote_timer > 0):
				velocity.y = jump_force
				coyote_timer = 0
				change_state(State.JUMPING)
				
			if is_on_floor() and jump_buffer_timer > 0:
				jump_buffer_timer = 0
				
			if jump_buffer_timer > 0:
				jump_buffer_timer -= delta
		

		
			if velocity.x > 0:
				animated_sprite.flip_h = false
			elif velocity.x < 0:
				animated_sprite.flip_h = true
			
			if global_position.x <= 0:
				global_position.x = 0
		else:
			velocity.x = lerp(velocity.x, 0.0, 0.03)
			if velocity.x < 10 and is_on_floor():
				velocity.x = 0
				state = State.IDLE
				
		
		
		
	else:
		velocity = Vector2(0, 0)
		
	handle_state(delta)
	move_and_slide()

func handle_state(delta):
	match state:
		State.IDLE:
			animated_sprite.play("idle")
			if not is_on_floor():
				change_state(State.FALLING)
			if not disabled:
				if Input.is_action_pressed("ui_left") or Input.is_action_pressed("ui_right"):
					change_state(State.RUNNING)
		
		State.RUNNING:
			animated_sprite.play("running")
			if not is_on_floor():
				change_state(State.FALLING)
			if not disabled:
				if not (Input.is_action_pressed("ui_left") or Input.is_action_pressed("ui_right")):
					change_state(State.IDLE)
		
		State.JUMPING:
			animated_sprite.play("jump")
			if velocity.y >= 0:
				change_state(State.FALLING)
		
		State.FALLING:
			animated_sprite.play("fall")
			if Input.is_action_just_pressed("ui_accept") and coyote_timer > 0:
				velocity.y = jump_force
				coyote_timer = 0
				change_state(State.JUMPING)
			elif is_on_floor():
				if Input.is_action_pressed("ui_left") or Input.is_action_pressed("ui_right"):
					change_state(State.RUNNING)
				else:
					change_state(State.IDLE)
			

func change_state(new_state):
	if state == new_state:
		return
	state = new_state
	
func die() -> void:
	if not state == State.DEAD:
		$AudioStreamPlayer.playing = true
		change_state(State.DEAD)
		animated_sprite.play("die")
		await animated_sprite.animation_finished
		animated_sprite.queue_free()
		Transition.change_scene(get_tree().current_scene.scene_file_path)
		
func disable() -> void:
	disabled = true
	

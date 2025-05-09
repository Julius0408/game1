extends Area2D

signal life_lost
signal defeated
signal outro

@export var projectile_number: int = 12
@export var max_life_number: int = 6
@export var max_soul_parts: int = 2

var current_life_number: int
var current_soul_parts: Array = []
var is_defeated = false

var screen_width = 1280/2
var screen_height = 800/2

var projectile = preload("res://scenes/boss_projectile.tscn")
var soul_part = preload("res://scenes/soul_particle.tscn")

func _ready() -> void:
	current_life_number = max_life_number
	connect("defeated", on_defeated)


func _process(delta: float) -> void:
	if current_life_number <= 0 and not is_defeated:
		emit_signal("defeated")

		$AnimatedSprite2D.play("die")
		await $AnimatedSprite2D.animation_finished
		$EndTimer.start()
		await $EndTimer.timeout
		queue_free()


func _on_position_change_timeout() -> void:
	if not is_defeated:
		$AnimatedSprite2D.play("despawn")
		await $AnimatedSprite2D.animation_finished
		while true:
			var new_position = Vector2(randf_range(0, screen_width),randf_range(0, screen_height))
			if can_spawn(new_position):
				self.position = new_position
				break
			continue
			
		if get_parent().get_node("Character").global_position.x < global_position.x:
			scale.x = -1
		else: 
			scale.x = 1
			
		$AnimatedSprite2D.play("preshadow")
		await $AnimatedSprite2D.animation_finished
		
		$PositionChange.start()
		$AnimatedSprite2D.play_backwards("fire")
		fire_radial_projectiles(self.global_position, projectile_number, 250)
		spawn_soul_parts()
		await $AnimatedSprite2D.animation_finished
		$AnimatedSprite2D.play("idle")

	
	
func fire_radial_projectiles(center_pos: Vector2, count: int, speed: float):
	for i in range(count):
		var angle = (float(i) / count) * TAU
		var direction = Vector2(cos(angle), sin(angle))
		
		var bullet = projectile.instantiate()
		bullet.position = center_pos
		bullet.velocity = direction * speed
		connect("defeated", Callable(bullet, "queue_free"))
		
		get_tree().current_scene.add_child(bullet)
		
func spawn_soul_parts() -> void:
	for i in range(max_soul_parts):
		var new_soul_part = soul_part.instantiate()
		while true:
			var new_position = Vector2(randf_range(0, screen_width),randf_range(0, screen_height))
			if can_spawn(new_position):
				new_soul_part.position = new_position
				break
			continue
		new_soul_part.connect("life_removed", remove_life)
		connect("defeated", Callable(new_soul_part, "_on_lifetime_timeout"))
		current_soul_parts.append(new_soul_part)
		get_tree().current_scene.add_child(new_soul_part)
		
	
func can_spawn(position: Vector2) -> bool:
	var space_state = get_world_2d().direct_space_state

	var query = PhysicsPointQueryParameters2D.new()
	query.position = position
	query.collide_with_areas = true
	query.collide_with_bodies = false

	var result = space_state.intersect_point(query)

	for collision in result:
		var collider = collision.collider
		if collider is BossForbittenArea:
			return false
	return true
	
func remove_life() -> void:
	current_life_number -= 1
	emit_signal("life_lost")
	
func on_defeated():
	is_defeated = true
	$AnimatedSprite2D.play("die")
	await $AnimatedSprite2D.animation_finished
	$AnimatedSprite2D.queue_free()
	$EndTimer.start()
	await $EndTimer.timeout
	emit_signal("outro")
	queue_free()

	

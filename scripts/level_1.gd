extends Node2D

@onready var camera = $Character/Camera2D
@onready var tilemap = $TileMapLayer
@onready var checkpoint = $Checkpoint
@onready var menu = $InLevelMenu
@onready var window_size = get_window().get_size()


func _ready() -> void:
	if GameManager.get_checkpoint_pos():
		$Character.global_position = GameManager.get_checkpoint_pos()
	var tilemap_width = tilemap.get_used_rect().size.x * 16
	var tilemap_height = tilemap.get_used_rect().size.y * 16
		
	camera.limit_left = 0
	camera.limit_right = max(tilemap_width, window_size.x)
	camera.limit_top = 0
	camera.limit_bottom = tilemap_height - window_size.y
	if camera.limit_bottom < 0:
		camera.limit_bottom = 0
		
	$Checkpoint.connect("activated", checkpoint_activated)
	GameManager.player_won.connect(fade_out_music)
	
	
	
func checkpoint_activated(position: Vector2) -> void:
	GameManager.set_checkpoint_pos(position)
	

func fade_out_music(duration: float = 2.0):
	var tween = create_tween()
	tween.tween_property($AudioStreamPlayer, "volume_db", -80.0, duration)
	tween.tween_callback(Callable($AudioStreamPlayer, "stop")).set_delay(duration)
	
func pause():
	get_tree().paused = true
	
func resume():
	get_tree().paused = false
	menu.hide()
	
func restart():
	resume()
	Transition.change_scene(get_tree().current_scene.scene_file_path)
	
func quit():
	resume()
	Transition.change_scene("res://scenes/main_menu.tscn")

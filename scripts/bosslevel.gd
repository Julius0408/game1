extends Node2D

@onready var menu = $InLevelMenu


func _ready() -> void:
	$Boss.connect("defeated", fade_out_music)
	$Boss.connect("outro", win)


func _process(delta: float) -> void:
	pass

func win() -> void:
	for i in $Confetti.get_children():
		i.emitting = true
	$LevelExitTimer.start()
	await $LevelExitTimer.timeout
	Transition.change_scene("res://scenes/main_menu.tscn")
	
func fade_out_music(duration: float = 2.0):
	var tween = create_tween()
	tween.tween_property($AudioStreamPlayer, "volume_db", -80.0, duration)
	tween.tween_callback(Callable($AudioStreamPlayer, "stop")).set_delay(duration)
	
func on_defeated() -> void:
	$Character.disable()
	$Winsound.playing = true
	fade_out_music()
	
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

extends CanvasLayer

func change_scene(path: String) -> void:
	$AnimationPlayer.play("circle_transition")
	await $AnimationPlayer.animation_finished
	get_tree().change_scene_to_file(path)
	$AnimationPlayer.play_backwards("circle_transition")
	await $AnimationPlayer.animation_finished
	

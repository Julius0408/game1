extends CanvasLayer

func _ready() -> void:
	$Panel/VBoxContainer/PlayButton.grab_focus()

	for child in $Panel/VBoxContainer.get_children():
		if child is Button:
			child.connect("mouse_entered", Callable(child, "grab_focus"))


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		if visible:
			get_parent().resume()
			hide()
		else:
			show()
			get_parent().pause()
			$Panel/VBoxContainer/PlayButton.grab_focus()

			

func _on_play_button_pressed() -> void:
	get_parent().resume()

func _on_restart_button_pressed() -> void:
	get_parent().restart()

func _on_cancel_button_pressed() -> void:
	get_parent().quit()

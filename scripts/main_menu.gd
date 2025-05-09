extends Control

@onready var level1_button = $Panel/VBoxContainer/Level1Button
@onready var level2_button = $Panel/VBoxContainer/Level2Button
@onready var level3_button = $Panel/VBoxContainer/Level3Button
@onready var level4_button = $Panel/VBoxContainer/Level4Button
@onready var quit_button = $Panel/VBoxContainer/QuitButton

func _ready() -> void:
	level1_button.grab_focus()
	
	for child in $Panel/VBoxContainer.get_children():
		if child is Button:
			child.connect("mouse_entered", Callable(child, "grab_focus"))


func _on_level_1_button_pressed() -> void:
	Transition.change_scene("res://scenes/level_1.tscn")
	
func _on_level_2_button_pressed() -> void:
	Transition.change_scene("res://scenes/level_2.tscn")

func _on_level_3_button_pressed() -> void:
	Transition.change_scene("res://scenes/level_3.tscn")

func _on_level_4_button_pressed() -> void:
	Transition.change_scene("res://scenes/bosslevel.tscn")

func _on_quit_button_pressed() -> void:
	get_tree().quit()

func _on_level_1_button_mouse_entered() -> void:
	level1_button.grab_focus()

extends Node2D

@export var heart_full: Texture2D
@export var heart_empty: Texture2D
@export var max_heart_number: int = 6
@export var boss: Node2D
var current_heart_number: int

func _ready():
	for i in max_heart_number:
		var heart = TextureRect.new()
		heart.texture = heart_full
		heart.expand = true
		heart.expand_mode = TextureRect.EXPAND_KEEP_SIZE
		heart.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		$HBoxContainer.add_child(heart)
		
	if boss.has_signal("life_lost"):
		boss.connect("life_lost", update_hearts)
		
	current_heart_number = max_heart_number


func _process(delta: float) -> void:
	pass
	
			
func update_hearts():
	current_heart_number -= 1
	for i in $HBoxContainer.get_child_count():
		var heart = $HBoxContainer.get_child(i) as TextureRect
		if i < current_heart_number:
			heart.texture = heart_full
		else:
			heart.texture = heart_empty


func _on_lifetime_timeout() -> void:
	queue_free()

extends Button


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_pressed() -> void:
	var startStoryScene = preload("res://scenes/UI/StartStory.tscn")
	FancyFade.horizontal_paint_brush(startStoryScene.instantiate())
	#get_tree().change_scene_to_file("res://scenes/UI/StartStory.tscn")

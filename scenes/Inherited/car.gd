extends StaticBody3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func showM():
	$Sprite3D.visible = true
func hideM():
	$Sprite3D.visible = false

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("interract") and $Sprite3D.visible:
		print("YOU WIN!!")
		var winScene = preload("res://scenes/UI/Win.tscn")
		FancyFade.horizontal_paint_brush(winScene.instantiate())
		#get_tree().change_scene_to_file("res://scenes/UI/Win.tscn")

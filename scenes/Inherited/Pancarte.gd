extends StaticBody3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("interract") and %Sprite3D.visible:
		%TextureRect.visible = !%TextureRect.visible
		Player.clickedPancarte = true

func showInterraction():
	if !%Sprite3D.visible:
		%Sprite3D.visible = true

func hideInterraction():
	if %Sprite3D.visible:
		%TextureRect.visible = false
		%Sprite3D.visible = false

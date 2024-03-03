extends Node3D

var look = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Player.setPosition and look:
		look_at(Player.setPosition)

func stopLook():
	look = false

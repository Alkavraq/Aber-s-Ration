extends DirectionalLight3D

var raised = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	rotation.x = 0
	light_energy = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if global.raiseSun and !raised:
		raised = true
		var sunTween = create_tween()
		sunTween.parallel().tween_property(self, "light_energy", 3.5, 5)
		sunTween.parallel().tween_property(self, "rotation:x", deg_to_rad(-50), 5)

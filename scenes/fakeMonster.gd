extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if randi_range(1, 200) == 1:
		var tween = create_tween()
		tween.tween_property(self, "global_position", Vector3(global_position.x + randi_range(-5, 5),global_position.y + randi_range(-5, 5),global_position.z), 3)


func _on_timer_timeout() -> void:
	queue_free()

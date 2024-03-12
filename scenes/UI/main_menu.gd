extends Node3D

@onready var fMonster = preload("res://scenes/fakeMonster.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for x in 50:
		var newEyes = fMonster.instantiate()
		newEyes.global_position = Vector3(randi_range(-20,20), randi_range(-10, 10), 0)
		add_child(newEyes)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if randi_range(1, 50) == 1:
		var newEyes = fMonster.instantiate()
		newEyes.global_position = Vector3(randi_range(-20,20), randi_range(-10, 10), 0)
		add_child(newEyes)
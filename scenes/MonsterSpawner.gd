extends Node3D

var hasMonster = false
var monster = preload("res://scenes/monster.tscn")
var ToStop = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !hasMonster:
		var newM = monster.instantiate()
		#newM.global_position = self.global_position
		newM.speed = 0
		add_child(newM)
		hasMonster = true
	if hasMonster:
		if get_child(0).get_node("AnimationPlayer").is_playing() and !ToStop:
			ToStop = true
			await get_tree().create_timer(2)
			print("kkk")
			for x in get_children():
				x.queue_free()
			hasMonster = false
			ToStop = false


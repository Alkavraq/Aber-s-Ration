extends Node3D

var look = true
var counted = false

@onready var playerFinder = $PlayerFinder

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _physics_process(delta: float) -> void:
	if playerFinder.is_colliding():
		if playerFinder.get_collider().is_in_group("player") and !counted:
			Player.seenByMonstersCount += 1
			var hrTween = create_tween()
			hrTween.tween_property(Player, "HRfromLooks", 10*Player.seenByMonstersCount, 5)
			counted = true
		elif !playerFinder.get_collider().is_in_group("player") and counted:
			Player.seenByMonstersCount -= 1
			var hrTween = create_tween()
			hrTween.tween_property(Player, "HRfromLooks", 10*Player.seenByMonstersCount, 5)
			counted = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Player.setPosition and look:
		look_at(Player.setPosition)

func stopLook():
	look = false
	

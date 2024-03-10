extends Node3D

var look = true
var counted = false
var contact = false

@export var speed := 1.25

@onready var playerFinder = $PlayerFinder

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#$Body.mesh.material.transparency = 1
	pass

func _physics_process(delta: float) -> void:
	if playerFinder.is_colliding() and look:
		if playerFinder.get_collider().is_in_group("player"):
			if !counted:
				Player.seenByMonstersCount += 1
				var hrTween = create_tween()
				hrTween.tween_property(Player, "HRfromLooks", 10*Player.seenByMonstersCount, 5)
				counted = true
			if self.global_position.distance_to(playerFinder.get_collision_point()) < 12.5 and !contact:
				#print("forward!")
				self.global_position = Vector3(move_toward(global_position.x, playerFinder.get_collision_point().x, delta * speed), move_toward(global_position.y, playerFinder.get_collision_point().y, delta * speed), move_toward(global_position.z, playerFinder.get_collision_point().z, delta * speed))
				#self.global_position = move_toward(global_position, playerFinder.get_collision_point(), delta * speed)
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
	
func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("player") and visible and !$AnimationPlayer.is_playing():
		contact = true
		if Player.CampfirePlaced and !Player.sleeping:
			Player.forceSleep = true

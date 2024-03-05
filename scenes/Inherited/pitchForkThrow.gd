extends RigidBody3D
class_name ThrownSpear

@export var throwForce = 20

@onready var SpearKey = $SpearKey

var previousYs
var variation

static var hitground = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#add_constant_force(Vector3(0, -5, 0), Vector3(0, -2, 0))
	#apply_impulse(Vector3(0, -50, 0), Vector3(0, -2, 0))
	pass

func _physics_process(delta: float) -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Player.Weapon.visible:
		self.visible = false
		SpearKey.visible = false
	#print(get_contact_count())
	pass

func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("interract") and hitground and SpearKey.visible:
		SpearKey.visible = false
		Player.Weapon.visible = true
		self.visible = false
		hitground = false
		$CollisionShape.disabled = true
		rayon.shown = false
		Player.startMonitor = true
		await get_tree().create_timer(2).timeout
		queue_free()

func showKey(value):
	if hitground:
		if value:
			SpearKey.visible = true
		if !value:
			SpearKey.visible = false

func throw():
	linear_velocity = quaternion * Vector3.MODEL_TOP * throwForce 
	#look_at(global_transform.origin + linear_velocity, Vector3(0, 1, 0))
	#var direction = _get_direction()
	#transform = transform.looking_at(global_position + direction, Vector3.UP)
	#linear_velocity = direction * throwForce

func _integrate_forces(state: PhysicsDirectBodyState3D) -> void:
	#angular_velocity.z = -0.5
	#look_at(linear_velocity.normalized(), Vector3(0,-1,0))  
	#self.rotation.z = self.linear_velocity.y
	
	#if previousYs:
		#variation = (linear_velocity.y - previousYs) *10
	#previousYs = linear_velocity.y
	#if variation:
		#rotation.z = variation
	pass
	
	
#func _get_direction():

	#var viewport := get_viewport()
	#var camera := viewport.get_camera_3d()
	#var center:Vector2 = viewport.size/2
	#
	#var from: Vector3 = camera.project_ray_origin(center)
	#var to:Vector3 = from + camera.project_ray_normal(center) *1000
	#
	#var query := PhysicsRayQueryParameters3D.create(from, to)
	#var collision = get_world_3d().direct_space_state.intersect_ray(query)
	#if collision:
		#return global_position.direction_to(collision.position)
	#else:
		#return global_position.direction_to(to)

func _on_area_body_entered(body: Node3D) -> void:
	#print(body)
	if body.is_in_group("monster"):
		
		SpearKey.visible = false
		Player.Weapon.visible = true
		self.visible = false
		hitground = false
		Player.startMonitor = true
		
		print("killim")
		for x in body.get_children():
			if x.is_in_group("animator"):
				Player.seenByMonstersCount -= 1
				var hrTween = create_tween()
				hrTween.tween_property(Player, "HRfromLooks", 10*Player.seenByMonstersCount, 5)
				x.play("Dead")
				x.get_parent().stopLook()
				#await get_tree().create_timer(1).timeout
				#body.queue_free()
				
	if body.name == "Terrain3D" or body.get_parent().name == "Road" and self.visible:
		await get_tree().create_timer(1).timeout
		hitground = true
		

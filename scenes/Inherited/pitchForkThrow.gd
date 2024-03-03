extends RigidBody3D

@export var throwForce = 15

var previousYs
var variation

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if previousYs:
		variation = (linear_velocity.y - previousYs) *-10
	previousYs = linear_velocity.y
	if variation:
		angular_velocity.z = variation
	

func throw():
	linear_velocity = quaternion * Vector3.MODEL_TOP * throwForce 
	#var direction = _get_direction()
	#transform = transform.looking_at(global_position + direction, Vector3.UP)
	#linear_velocity = direction * throwForce
	
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

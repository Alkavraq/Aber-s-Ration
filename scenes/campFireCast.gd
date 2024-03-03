extends RayCast3D

var pancarte
var lance

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$Campfire.global_rotation = Vector3(0,0,0)
	if is_colliding():
		$Campfire.global_position = get_collision_point()
		#print(get_collision_point())
		#print(get_collider())
		if get_collider().has_method("showKey"):
			lance = get_collider()
			lance.call("showKey", true)
		if get_collider().has_method("showInterraction"):
			pancarte = get_collider()
			pancarte.call("showInterraction")
	
	else:
		if lance:
			lance.call("showKey", false)
		if pancarte:
			pancarte.call("hideInterraction")
		$Campfire.position.z = -4.737 

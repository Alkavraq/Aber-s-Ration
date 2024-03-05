extends RayCast3D
class_name rayon

var pancarte
var lance
static var shown

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
			shown = true
		if get_collider().has_method("showInterraction"):
			pancarte = get_collider()
			pancarte.call("showInterraction")
	
	else:
		if lance and shown:
			lance.call("showKey", false)
			shown = false
		if pancarte:
			pancarte.call("hideInterraction")
		$Campfire.position.z = -4.737 

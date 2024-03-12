extends RayCast3D
class_name rayon

var pancarte
var lance
var voiture
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
		if get_collider().is_in_group("car"):
			voiture = get_collider()
			voiture.call("showM")
	
	else:
		if lance: 
			if shown:
				lance.call("showKey", false)
				shown = false
		if pancarte:
			pancarte.call("hideInterraction")
		if voiture:
			voiture.call("hideM")
		$Campfire.position.z = -4.737 

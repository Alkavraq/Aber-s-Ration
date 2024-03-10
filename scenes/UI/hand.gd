extends TextureRect
class_name watchTime

var started := false
var endDeg = 175
var time = 50

static var ToPause = false
static var addRand = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	rotation = deg_to_rad(-50)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Player.CampfirePlaced and !started:
		started = true
		var appearTween = create_tween()
		appearTween.tween_property(get_parent(), "modulate", Color(1,1,1,1), 1)
	if started and !ToPause:
		self.rotation += ((deg_to_rad(endDeg)-deg_to_rad(-50))/time) * delta
		#WatchTween.tween_property(self, "rotation", deg_to_rad(175), 50)
		#await WatchTween.finished
		#global.win()
	if rotation >= deg_to_rad(endDeg):
		global.win()
	if addRand:
		var degs = randi_range(10, 30)
		self.rotation += deg_to_rad(degs)
		addRand = false
	


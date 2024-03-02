extends OmniLight3D

var time:float
var randfV:=0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if randi_range(1,10) == 1 :
		randfV = randf()*2
	time += delta
	self.light_energy = clamp(sin(time)+randfV+7, 1, 10)
	

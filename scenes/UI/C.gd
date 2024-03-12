extends HBoxContainer

@onready var label = $Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !Player.CampfirePlaced:
		visible = true
	else : visible = false
		
func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("campfire") and visible:
		if label.text == "Place campfire":
			label.text = "Hide campfire"
		elif label.text == "Hide campfire" :
			label.text = "Place campfire"

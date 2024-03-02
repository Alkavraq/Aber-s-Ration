extends TextureRect

@onready var Critical = preload("res://assets/2d/Icons/HeartRateCritical.png")
@onready var Normal = preload("res://assets/2d/Icons/HeartRate.png")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_heart_rate_value_changed(value: float) -> void:
	if value >= 185 :
		self.texture = Critical
	else :
		self.texture = Normal

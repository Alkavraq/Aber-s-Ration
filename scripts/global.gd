extends Node

var raiseSun = false
var winV = false
var wannaFall = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

#func _unhandled_input(event: InputEvent) -> void:
	#if Input.is_action_just_pressed("ui_cancel"):
	##if event.is_action_pressed("ui_cancel"):
		#print("quit!!")
		#get_tree().quit()

func playerWakeUp():
	Player.wakeUP = true

func win():
	winV = true
	raiseSun = true

func fallToGround():
	wannaFall = true

func switchToGame():
	get_tree().change_scene_to_file("res://scenes/game_map.tscn")
	
func switchToLast():
	get_tree().change_scene_to_file("res://scenes/UI/endMenu.tscn")

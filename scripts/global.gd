extends Node

var raiseSun = false
var winV = false
var wannaFall = false

var loading
var brightness = 1.01

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
func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("upBrightness"):
		brightness += 0.05
	if Input.is_action_just_pressed("downBrightness"):
		brightness -= 0.05
	

func playerWakeUp():
	Player.wakeUP = true

func win():
	if !winV:
		Dialogic.start("getToRoad")
	winV = true
	raiseSun = true

func fallToGround():
	wannaFall = true

func loadGame():
	loading = ResourceLoader.load_threaded_request("res://scenes/game_map.tscn")

func switchToGame():
	var newScene = ResourceLoader.load_threaded_get("res://scenes/game_map.tscn")
	#FancyFade.cross_fade(newScene)
	get_tree().change_scene_to_packed(newScene)
	#get_tree().change_scene_to_file("res://scenes/game_map.tscn")
	
func switchToLast():
	var lastScene = preload("res://scenes/UI/endMenu.tscn")
	FancyFade.cross_fade(lastScene.instantiate())
	#get_tree().change_scene_to_file("res://scenes/UI/endMenu.tscn")


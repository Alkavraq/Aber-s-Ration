class_name Player extends CharacterBody3D

@export_category("Player")
@export_range(1, 35, 1) var speed: float = 10 # m/s
@export_range(10, 400, 1) var acceleration: float = 100 # m/s^2
@export var strenght := 5.0

@export_range(0.1, 3.0, 0.1) var jump_height: float = 1 # m
@export_range(0.1, 3.0, 0.1, "or_greater") var camera_sens: float = 1

var jumping: bool = false
var mouse_captured: bool = false

var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")

var move_dir: Vector2 # Input direction for movement
var look_dir: Vector2 # Input direction for look/aim

var walk_vel: Vector3 # Walking velocity 
var grav_vel: Vector3 # Gravity velocity 
var jump_vel: Vector3 # Jumping velocity

var CampfirePlaced = false
var weaponArmed = false
var campfire 
var distanceToCampfire = 0.0
var monstresDansLance = []
var killing = false
static var setPosition
static var startMonitor = false
static var wakeUP = false
static var sleeping = false

static var seenByMonstersCount = 0
const defaultHR = 80
static var waterDepricationSpeed = 0.5
static var CurrentWater = 100
static var foodDepricationSpeed = 0.3
static var CurrentFood = 100
static var heartRate = 80
static var HRfromLooks:=0.0

var globalDelta

@onready var camera: Camera3D = $Camera3D
@onready var RealCampfire = preload("res://scenes/Inherited/CampFire.tscn")
@onready var WeaponAnimationPlayer = $Camera3D/PitchFork/AnimationPlayer
@onready var WeaponLoc = $Camera3D/PitchFork
@onready var Crosshair = $Crosshair/TextureRect
@onready var WeaponThrowed = preload("res://scenes/Inherited/pitchForkThrow.tscn")
#@onready var playerMonsterScatter = $ProtonScatter
@onready var MonsterScene = preload("res://scenes/monster.tscn")
@onready var HitArea = $Camera3D/PitchFork/SM_Wep_Pitchfork_01/Area
@onready var wakeUpGraceTimer = $WakeUpGrace

static var Weapon

func _ready() -> void:
	Weapon=WeaponLoc
	capture_mouse()

func _process(delta: float) -> void:
	if wakeUP:
		FwakeUP()
	if startMonitor:
		$Camera3D/PitchFork/SM_Wep_Pitchfork_01/Area.monitoring = true
		startMonitor = false
	#print(seenByMonstersCount)
	if campfire :
		var campArrow = $CampfireArrow
		distanceToCampfire = self.global_position.distance_to(campfire.global_position)
		#if distanceToCampfire >= 10:
		if distanceToCampfire >= 1:
			campArrow.visible = true
			if self.global_position.z-campfire.global_position.z >= 0:
				campArrow.rotation.y = (atan((self.global_position.x-campfire.global_position.x)/(self.global_position.z-campfire.global_position.z))) -90
			else : 
				campArrow.rotation.y = (atan((self.global_position.x-campfire.global_position.x)/(self.global_position.z-campfire.global_position.z))) +45
		else :
			campArrow.visible = false
		#print(distanceToCampfire)
	globalDelta = delta
	setPosition = global_position

func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("campfire") and CampfirePlaced == false:
		$Camera3D/RayCast3D/Campfire.visible = !$Camera3D/RayCast3D/Campfire.visible
	if Input.is_action_just_pressed("LMB") and $Camera3D/RayCast3D/Campfire.visible:
		placeCampfire()
	if Input.is_action_just_pressed("LMB") and !$Camera3D/RayCast3D/Campfire.visible and !WeaponAnimationPlayer.is_playing() and !weaponArmed:
		WeaponAnimationPlayer.play("Hit")
		killing = true
	if Input.is_action_pressed("RMB") and weaponArmed == false and Weapon.visible:
		showCrosshair(true)
		WeaponAnimationPlayer.play("ReadyToFire")
	if Input.is_action_just_released("RMB"):
		weaponArmed = false
		showCrosshair(false)
		WeaponAnimationPlayer.play_backwards("ReadyToFire")
	if Input.is_action_just_pressed("LMB") and weaponArmed:
		throwWeapon()
	if event is InputEventMouseMotion:
		look_dir = event.relative * 0.001
		if mouse_captured: _rotate_camera()
	if Input.is_action_just_pressed("jump"): jumping = true

func _physics_process(delta: float) -> void:
	#print(monstresDansLance)
	if WeaponAnimationPlayer.current_animation == "Hit" and killing:
		#print("killim")
		for body in monstresDansLance:
			for x in body.get_children():
				if x.is_in_group("animator"):
					Player.seenByMonstersCount -= 1
					var hrTween = create_tween()
					hrTween.tween_property(Player, "HRfromLooks", 10*Player.seenByMonstersCount, 5)
					x.play("Dead")
					x.get_parent().stopLook()
					break
					#await get_tree().create_timer(1).timeout
					#body.queue_free()
		killing = false
					
	#if mouse_captured: _handle_joypad_camera_rotation(delta)
	if CampfirePlaced:
		#camera.attributes.exposure_multiplier = 0.0
		if wakeUpGraceTimer.is_stopped():
			if sleepiness() <= 0.05 and Dialogic.current_timeline == null:
				sleeping = true
				camera.attributes.exposure_multiplier = 0.0
				campfire.get_node("GPUParticles3D").visible = false
				Dialogic.start("deathTimeline")
				release_mouse()
	spawnMonsters()
	depricate(delta)
	velocity = _walk(delta) + _gravity(delta) + _jump(delta)
	if !sleeping:
		move_and_slide()

func sleepiness():
	if randi_range(1, 50) == 1:
		camera.attributes.exposure_multiplier -= randf_range(0.01, 0.05)
	camera.attributes.exposure_multiplier = clamp(camera.attributes.exposure_multiplier, 0, 2)
	return camera.attributes.exposure_multiplier

func FwakeUP():
	wakeUpGraceTimer.start(20)
	sleeping = false
	wakeUP = false
	capture_mouse()
	self.global_position = Vector3(randi_range(1, 299), 20 ,randi_range(-149, 149))
	await get_tree().create_timer(0.02).timeout
	self.global_position.y = $GroundFinder.get_collision_point().y + 2
	campfire.get_node("GPUParticles3D").visible = true 
	var upTween = create_tween()
	#upTween.tween_property(camera, "attributes.exposure_multiplier", 1.0, 3)
	camera.attributes.exposure_multiplier = 1.0
	wakeUpGraceTimer.start()
	

func spawnMonsters():
	if CampfirePlaced:
		if randi_range(1,100) == 1:
			$MonsterSpawnAxis.rotate_y(deg_to_rad(randi_range(1, 360)))
			if $MonsterSpawnAxis/MonsterSpawnPoint.global_position.x > 1 and $MonsterSpawnAxis/MonsterSpawnPoint.global_position.x < 300 and $MonsterSpawnAxis/MonsterSpawnPoint.global_position.z > -150 and $MonsterSpawnAxis/MonsterSpawnPoint.global_position.z < 150: 
				var nouveauMonstre = MonsterScene.instantiate()
				var groundFinderRay
				nouveauMonstre.global_position = Vector3($MonsterSpawnAxis/MonsterSpawnPoint.global_position.x, $MonsterSpawnAxis/MonsterSpawnPoint.global_position.y + 10, $MonsterSpawnAxis/MonsterSpawnPoint.global_position.z) 
				get_parent().add_child(nouveauMonstre)
				groundFinderRay = nouveauMonstre.get_node("GroundFinder")
				#for x in nouveauMonstre.get_children():
					#if x.name == "GroundFinder":
						#groundFinderRay = x
					#if x.name == "TopFinder":
						#topFinderRay = x
				await get_tree().create_timer(0.02).timeout
				if groundFinderRay:
					#print("Bonjour")
					if groundFinderRay.is_colliding():
						#print("1")
						nouveauMonstre.global_position.y = groundFinderRay.get_collision_point().y + 0.8
					elif !groundFinderRay.is_colliding():
						nouveauMonstre.queue_free()
					#print("3")
					#nouveauMonstre.global_position.y += 1
					
			#if playerMonsterScatter.modifier_stack.stack[0].instance_count == 0 :
				#playerMonsterScatter.modifier_stack.stack[0].instance_count += 1
				#print("one moreeeeeeeeeeeeeee")
			##await get_tree().create_timer(1).timeout
			#if $ProtonScatter/ScatterOutput.has_node("ScatterItem"):
			##if $ProtonScatter/ScatterOutput.get_child(0):
				#print("one moreeaaaaaaaaaaaaaa")
				#var NewMonsters = $ProtonScatter/ScatterOutput/ScatterItem.get_children()
				#var NewMonsterPos
				#for x in NewMonsters:
					#if x.is_in_group("monster"):
						#NewMonsterPos = x.global_position
						##if NewMonsterPos.x >= 0 and NewMonsterPos.x <= 300 and NewMonsterPos.z >= -150 and NewMonsterPos.z <= 150:
						#print("one more")
						#var nouveauMonstre = MonsterScene.instantiate()
						#nouveauMonstre.global_position = NewMonsterPos
						#get_parent().add_child(nouveauMonstre)
						#playerMonsterScatter.modifier_stack.stack[0].instance_count = 0
						#playerMonsterScatter.rotate_y(deg_to_rad(randi_range(1, 360)))
						#break

func throwWeapon():
	if Weapon.visible == true:
		Weapon.visible = false
		$Camera3D/PitchFork/SM_Wep_Pitchfork_01/Area.monitoring = false
		var thrownWeapon = WeaponThrowed.instantiate()
		thrownWeapon.global_transform = Weapon.global_transform
		get_parent().add_child(thrownWeapon)
		thrownWeapon.throw()

func depricate(delta):
	#print(HRfromLooks)
	heartRate = defaultHR + ((clamp((distanceToCampfire-15), 0, 200))/2.5) + HRfromLooks
	var extraDepricationFromHeartRate = clamp(((heartRate - 80) * 0.02), 0, 1000)
	if randi_range(1, 2) == 1:
		CurrentFood = CurrentFood - (foodDepricationSpeed + extraDepricationFromHeartRate) * delta
	if randi_range(1, 2) == 1:
		CurrentWater = CurrentWater - (waterDepricationSpeed + extraDepricationFromHeartRate) * delta

func showCrosshair(value):
	if value:
		var tween = create_tween()
		tween.tween_property(Crosshair, "modulate", Color(1,1,1,1), 0.6)
		tween.play()
	elif !value:
		var tween = create_tween()
		tween.tween_property(Crosshair, "modulate", Color(1,1,1,0), 0.6)

func placeCampfire():
	if $Camera3D/RayCast3D/Campfire/RootNode/RayCast3D.is_colliding():
		CampfirePlaced = true
		var newCampfire = RealCampfire.instantiate()
		newCampfire.global_position = $Camera3D/RayCast3D/Campfire.global_position
		$Camera3D/RayCast3D/Campfire.visible = false
		get_parent().add_child(newCampfire)
		campfire = newCampfire
		#playerMonsterScatter.rotate_y(deg_to_rad(randi_range(1, 360)))

func capture_mouse() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	mouse_captured = true

func release_mouse() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	mouse_captured = false

func _rotate_camera(sens_mod: float = 1.0) -> void:
	camera.rotation.y -= look_dir.x * camera_sens * sens_mod
	camera.rotation.x = clamp(camera.rotation.x - look_dir.y * camera_sens * sens_mod, -1.5, 1.5)

#func _handle_joypad_camera_rotation(delta: float, sens_mod: float = 1.0) -> void:
	#var joypad_dir: Vector2 = Input.get_vector("look_left","look_right","look_up","look_down")
	#if joypad_dir.length() > 0:
		#look_dir += joypad_dir * delta
		#_rotate_camera(sens_mod)
		#look_dir = Vector2.ZERO

func _walk(delta: float) -> Vector3:
	move_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_backwards")
	var _forward: Vector3 = camera.global_transform.basis * Vector3(move_dir.x, 0, move_dir.y)
	var walk_dir: Vector3 = Vector3(_forward.x, 0, _forward.z).normalized()
	walk_vel = walk_vel.move_toward(walk_dir * speed * move_dir.length(), acceleration * delta)
	return walk_vel

func _gravity(delta: float) -> Vector3:
	grav_vel = Vector3.ZERO if is_on_floor() else grav_vel.move_toward(Vector3(0, velocity.y - gravity, 0), gravity * delta)
	return grav_vel

func _jump(delta: float) -> Vector3:
	if jumping:
		if is_on_floor(): jump_vel = Vector3(0, sqrt(4 * jump_height * gravity), 0)
		jumping = false
		return jump_vel
	jump_vel = Vector3.ZERO if is_on_floor() else jump_vel.move_toward(Vector3.ZERO, gravity * delta)
	return jump_vel


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "ReadyToFire" and !Input.is_action_pressed("RMB"):
		weaponArmed = false
	if anim_name == "ReadyToFire" and Input.is_action_pressed("RMB"):
		print(anim_name)
		weaponArmed = true
	if anim_name == "Hit":
		killing = false

func _on_area_body_entered(body: Node3D) -> void:
	if WeaponAnimationPlayer.current_animation == "Hit" and body.is_in_group("monster"):
		print("killim")
		for x in body.get_children():
			if x.is_in_group("animator"):
				Player.seenByMonstersCount -= 1
				var hrTween = create_tween()
				hrTween.tween_property(Player, "HRfromLooks", 10*Player.seenByMonstersCount, 5)
				x.play("Dead")
				x.get_parent().stopLook()
				break
	if body.is_in_group("monster"):
		monstresDansLance.append(body)
		
func _on_area_body_exited(body: Node3D) -> void:
	if body.is_in_group("monster"):
		monstresDansLance.erase(body)

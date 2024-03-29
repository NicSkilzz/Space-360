extends KinematicBody2D


onready var health_bar = $CanvasLayer/health_bar
onready var movement_bus = AudioServer.get_bus_index("movement_bus")
onready var movement_sound = $CanvasLayer/movement_sound
onready var shooting_sound = $Shooting
onready var bullet_point = $BulletPoint
onready var save_file = GlobalWorld.game_data

export (int) var HEALTH = 100
export (int) var SPEED = 200
export (int) var ACCELERATION = 10
export (int) var FRICTION = 1
export (int) var BULLET_SPEED = 1000
export (float) var FIRE_RATE = 0.5



var input_direction = Vector2()
var velocity = Vector2()

var bullet = preload("res://Player/Bullet.tscn")
var can_fire = true

#onready var engine_sound = $EngineSound
func _process(_delta):
	look_at(get_global_mouse_position())
	
	if Input.is_action_pressed("fire") && can_fire:
		shoot()
		can_fire = false
		yield(get_tree().create_timer(FIRE_RATE), "timeout")# waits set amount of time, can change the time by changing the value of fire_rate
		can_fire = true


func get_input_direction():#movement direction
	input_direction = Vector2()
	
	if Input.is_action_pressed("ui_right"):
		input_direction.x += 1
	if Input.is_action_pressed("ui_left"):
		input_direction.x -= 1
	if Input.is_action_pressed("ui_down"):
		input_direction.y += 1
	if Input.is_action_pressed("ui_up"):
		input_direction.y -= 1
	
	input_direction = input_direction.normalized()

func _physics_process(delta):
	var input_dir = get_input_direction()
	if input_dir != 0:
		acceleration(input_direction)
		movement_sound_volume_play(velocity)#movement sound
	else:
		apply_friction()
		movement_sound_volume_stop()
	velocity = move_and_slide(velocity) * delta * 60
	#movement_sound()

func apply_friction():
	velocity = velocity.move_toward(Vector2.ZERO, FRICTION)

func acceleration(direction):
	velocity = velocity.move_toward(SPEED * direction, ACCELERATION)

func movement_sound_volume_play(sound_velocity):
	var velocity_length_pre = pow(sound_velocity.x, 2.0) + pow(sound_velocity.y, 2.0) 
	var velocity_length = pow(velocity_length_pre, 1/2.0)
	var movement_volume = velocity_length / SPEED * 30 - 35
	AudioServer.set_bus_mute(movement_bus, false)
	AudioServer.set_bus_volume_db(movement_bus, movement_volume)

func movement_sound_volume_stop():
	AudioServer.set_bus_mute(movement_bus, true)

func _on_player_area_area_entered(area):
	if area.name == "asteroid_area":
		HEALTH -= 20
		area.get_parent().queue_free()
		health_bar.value = HEALTH
	elif area.name == "enemy_bullet_area":
		HEALTH -= 20
		area.get_parent().queue_free()
		health_bar.value = HEALTH
	if HEALTH == 0:
# warning-ignore:return_value_discarded
		GlobalWorld.end_score = GlobalWorld.score
		GlobalWorld.score = 0
		if GlobalWorld.end_score > save_file.highscore:
			save_file.highscore = GlobalWorld.end_score
			GlobalWorld.save_highscore()
		get_tree().change_scene("res://Home Screen/death_screen.tscn")
		
	if area.name == "DeathArea":
# warning-ignore:return_value_discarded
		GlobalWorld.end_score = GlobalWorld.score
		GlobalWorld.score = 0
		if GlobalWorld.end_score > save_file.highscore:
			save_file.highscore = GlobalWorld.end_score
			GlobalWorld.save_highscore()
		get_tree().change_scene("res://Home Screen/death_screen.tscn")
	if area.name == "repair_item_area" && HEALTH <= 80:
		HEALTH += 20
		area.get_parent().queue_free()
		health_bar.value = HEALTH
	elif area.name == "repair_item_area":
		HEALTH = 100
		area.get_parent().queue_free()
		health_bar.value = HEALTH

func shoot():
	shooting_sound.play()
	var bullet_instance = bullet.instance()
	bullet_instance.position = bullet_point.get_global_position()
	# Change the position to make the shooting start at the edge 
	bullet_instance.rotation_degrees = rotation_degrees
	bullet_instance.apply_impulse(Vector2(),Vector2(BULLET_SPEED, 0).rotated(rotation))
	get_tree().get_root().add_child(bullet_instance)


extends KinematicBody2D

export (int) var SPEED = 200
export (int) var ACCELERATION = 10
export (int) var FRICTION = 1
export (int) var bullet_speed = 1000
export var fire_rate = 20000

var input_direction = Vector2()
var velocity = Vector2()

var bullet = preload("res://Player/Bullet.tscn")
var can_fire = true

#onready var engine_sound = $EngineSound
func _process(delta):
	look_at(get_global_mouse_position())
	#it seems like the deformity is caused because we set scale to 1, meaning that it can not use antiscaling to
	#make the borders look smoth, in turn deforming the sprite. So while we can use 16x16 pixel art we have to upscale
	#everything in order to make roation look smoth
	
	if Input.is_action_pressed("fire"):
		var bullet_instance = bullet.instance()
		bullet_instance.position = $BulletPoint.get_global_position()
		# Change the position to make the shooting start at the edge 
		bullet_instance.rotation_degrees = rotation_degrees
		bullet_instance.apply_impulse(Vector2(),Vector2(bullet_speed, 0).rotated(rotation))
		get_tree().get_root().add_child(bullet_instance)
		can_fire = false
		yield(get_tree().create_timer(fire_rate), "timeout")
		can_fire = true
	


func get_input_direction():
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
	else:
		apply_friction()
	velocity = move_and_slide(velocity) * delta * 60
	#movement_sound()

func apply_friction():
	velocity = velocity.move_toward(Vector2.ZERO, FRICTION)

func acceleration(direction):
	velocity = velocity.move_toward(SPEED * direction, ACCELERATION)

#func movement_sound():
#	var engine_sound_play = false
#	if not engine_sound.is_playing() and velocity != Vector2.ZERO:
#		engine_sound.play()
#		engine_sound_play = true
#	while engine_sound_play:
#		var engine_volume = engine_sound.set_volume_db(0)
#		engine_volume += engine_volume + 1 


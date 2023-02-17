extends KinematicBody2D

export (int) var SPEED = 200
export (int) var ACCELERATION = 10
export (int) var FRICTION = 1

var input_direction = Vector2()
var velocity = Vector2()

#onready var engine_sound = $EngineSound

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


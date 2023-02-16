extends KinematicBody2D

export (int) var SPEED = 200
export (int) var ACCELERATION = 10
export (int) var FRICTION = 1

var input_direction = Vector2()
var velocity = Vector2()

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
	velocity = move_and_slide(velocity)

func apply_friction():
	velocity = velocity.move_toward(Vector2.ZERO, FRICTION)

func acceleration(direction):
	velocity = velocity.move_toward(SPEED * direction, ACCELERATION)

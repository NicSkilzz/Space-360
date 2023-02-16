extends KinematicBody2D

export (int) var speed = 200

var velocity = Vector2()

func get_input(delta):
	velocity = Vector2()
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
	if Input.is_action_pressed("ui_down"):
		velocity.y += 1
	if Input.is_action_pressed("ui_up"):
		velocity.y -= 1
	velocity = velocity.normalized() * speed * delta * 60

func _physics_process(delta):
	get_input(delta)
	velocity = move_and_slide(velocity)

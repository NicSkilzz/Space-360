extends KinematicBody2D

export (int) var ENEMY_HEALTH = 100
export (int) var ENEMY_SPEED = 50
var motion = Vector2.ZERO
var player = null

onready var enemy_health_bar = $enemy_health_bar

func _on_enemy_space_ship_area_area_entered(area):
	if area.name == "bullet_area": 
		ENEMY_HEALTH -= 20
		area.get_parent().queue_free()
		enemy_health_bar.value = ENEMY_HEALTH
	if ENEMY_HEALTH == 0:
		queue_free()


func _physics_process(delta):
	motion = Vector2.ZERO
	if player:
		motion = position.direction_to(player.position) * ENEMY_SPEED
	motion = move_and_slide(motion)

func _on_enemy_scope_body_entered(body):
	if body.name == "Player":
		player = body

func _on_enemy_scope_body_exited(body):
	if body.name == "Player":
		player = null

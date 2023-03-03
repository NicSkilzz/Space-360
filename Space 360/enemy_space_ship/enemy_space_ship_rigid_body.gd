extends RigidBody2D

onready var rays = $rays
onready var enemy_sprite = $enemy_sprite
onready var tween = $Tween
onready var main_player = $"../Player"


export (int) var MAX_THRUST = 200
export (int) var ENEMY_HEALTH = 100
export (int) var MAX_SPEED = 100

onready var enemy_health_bar = $enemy_health_bar

func _on_enemy_space_ship_area_area_entered(area):
	if area.name == "bullet_area": 
		ENEMY_HEALTH -= 20
		area.get_parent().queue_free()
		enemy_health_bar.value = ENEMY_HEALTH
	if ENEMY_HEALTH == 0:
		queue_free()


func _integrate_forces(state):
	var delta = state.get_step()
	
	#Check the nearby objects with raycast
	var closest_collision = null
	rays.rotation += delta * 11 * PI
	for ray in rays.get_children():
		if ray.is_colliding():
			var collision_point = ray.get_collision_point() - global_position
			if closest_collision == null:
				closest_collision = collision_point
			if collision_point.length() < closest_collision.length():
				closest_collision = collision_point
	
	#Dodge
	if closest_collision:
		var normal = -closest_collision.normalized()
		var dodge_direction = 1
		if randf() < 0.5:
			dodge_direction = -1
		linear_velocity += normal * MAX_THRUST * 2 * delta
		linear_velocity += normal.rotated(PI/2 * dodge_direction) * MAX_THRUST * delta
	
	#Steer towards player
	var distance_to_player = global_position.distance_to(main_player.global_position)
	var vector_to_player = (main_player.global_position - global_position).normalized()
	
	#Rotate turret
	var start = enemy_sprite.rotation
	var angle_to_target = Vector2(1, 0).rotated(start).angle_to(vector_to_player)
	var end = start * angle_to_target
	tween.interpolate_property(enemy_sprite, "rotation", start, end, 0.1, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	tween.start()

	if distance_to_player > 100:
		#Move towards player
		linear_velocity += vector_to_player * MAX_THRUST * delta
	else:
		#Move away from player
		linear_velocity += -vector_to_player * MAX_THRUST * delta
	
	# Clamp max speed
	if linear_velocity.length() > MAX_SPEED:
		linear_velocity = linear_velocity.normalized() * MAX_SPEED

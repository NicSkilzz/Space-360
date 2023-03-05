extends RigidBody2D

onready var rays = $rays
onready var enemy_sprite = $enemy_sprite
onready var main_player = $"../Player"
onready var collision_polygon_2d = $enemy_space_ship_area/CollisionPolygon2D
onready var shoot_cooldown = $shoot_cooldown
onready var shooting_sound = $Shooting
onready var bullet_spawn_point = $enemy_sprite/bullet_spawn_point
onready var enemy_health_bar = $enemy_health_bar
onready var shooting_direction = $shooting_direction



export (int) var COOLDOWN = 3
export (int) var MAX_THRUST = 300
export (int) var ENEMY_HEALTH = 100
export (int) var MAX_SPEED = 100
export (int) var ROTATIONSPEED = 3
export (int) var BULLET_SPEED = 500
export (int) var REPAIR_KIT_CHANCE = 10


var bullet = preload("res://enemy_space_ship/enemy_bullet.tscn")
var repair_item = preload("res://Items/RepairItem.tscn")
var can_fire = false

func _on_enemy_space_ship_area_area_entered(area):
	if area.name == "bullet_area": 
		ENEMY_HEALTH -= 20
		area.get_parent().queue_free()
		enemy_health_bar.value = ENEMY_HEALTH
	if area.name == "asteroid_area":
		ENEMY_HEALTH -= 20
		area.get_parent().queue_free()
		enemy_health_bar.value = ENEMY_HEALTH
	if ENEMY_HEALTH == 0:
		if randi()%REPAIR_KIT_CHANCE+1 == 1:
			var repair_instance = repair_item.instance()
			repair_instance.position = enemy_sprite.global_position
			get_tree().get_root().add_child(repair_instance)
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
#	var angleTo = enemy_sprite.transform.x.angle_to(vector_to_player)
#	enemy_sprite.rotate(sign(angleTo) * min(delta * ROTATIONSPEED, abs(angleTo)))
#	collision_polygon_2d.rotate(sign(angleTo) * min(delta * ROTATIONSPEED, abs(angleTo)))
	look_at(main_player.global_position)
	
	if distance_to_player > 100 and closest_collision == null:
		#Move towards player
		linear_velocity += vector_to_player * MAX_THRUST * delta
	elif distance_to_player <= 100 and closest_collision == null:
		#Move away from player
		linear_velocity += -vector_to_player * MAX_THRUST * delta
	
	# Clamp max speed
	if linear_velocity.length() > MAX_SPEED:
		linear_velocity = linear_velocity.normalized() * MAX_SPEED

func shoot():
	shooting_sound.play()
	var bullet_instance = bullet.instance()
	bullet_instance.position = bullet_spawn_point.global_position 
	bullet_instance.global_rotation = shooting_direction.global_rotation + 1.5708
	var shooting_rotated = shooting_direction.global_rotation + 1.5708
	bullet_instance.apply_impulse(Vector2(),Vector2(BULLET_SPEED, 0).rotated(shooting_rotated))
	get_tree().get_root().add_child(bullet_instance)

func _on_shoot_cooldown_timeout():
	shoot_cooldown.wait_time = COOLDOWN * (1 + rand_range(-0.25, 0.25))
	shoot_cooldown.start()
	shoot()


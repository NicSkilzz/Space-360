extends KinematicBody2D

export (int) var ENEMY_HEALTH = 100

onready var enemy_health_bar = $enemy_health_bar

func _on_enemy_space_ship_area_area_entered(area):
	if area.name == "bullet_area": 
		ENEMY_HEALTH -= 20
		area.get_parent().queue_free()
		enemy_health_bar.value = ENEMY_HEALTH
	if ENEMY_HEALTH == 0:
		queue_free()

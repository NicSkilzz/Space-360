extends RigidBody2D





func _on_bullet_area_area_entered(area):
	if area.name == "DeathArea":
		queue_free()
	if area.name == "asteroid_area":
		queue_free()

extends RigidBody2D

export (int) var HEALTH = 1



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_asteroid_area_area_entered(area):
	if area.name == "bullet_area":
		HEALTH -= 1
		area.get_parent().queue_free()
	if HEALTH == 0:
		queue_free()
		
	if area.name == "DeathArea":
		queue_free()
		

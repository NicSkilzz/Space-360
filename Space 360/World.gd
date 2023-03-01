extends Node2D



var Asteroid = preload("res://Asteroid/Asteroid.tscn")
var Enemy = preload("res://enemy_space_ship/enemy_space_ship.tscn")


var rng = RandomNumberGenerator.new()
var rng2 = RandomNumberGenerator.new()
export (int) var asteroid_speed_range = 15


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_SpawnTimer_timeout():
	#var enemy = Enemy.instance()
	#add_child(enemy)
	#enemy.position = $ShipSpawn.position
	
	
	
	#change Spawn position
	var nodes = get_tree().get_nodes_in_group("spawn")# selec the spawn group
	var node = nodes[randi() % nodes.size()]# chose a random node in the spawn group
	
	# Set Spawn position to new position
	var position = node.position
	$ShipSpawn.position = position
	
	#$ShipSpawnTimer.wait_time = randi() % 5 + 5 # select random time between 5s and 10s
	


func _on_AsteroidSpawnRimer_timeout():
	var asteroid = Asteroid.instance()
	add_child(asteroid)
	asteroid.position = $AsteroidSpawn.position
	asteroid.apply_impulse(Vector2(), Vector2(rng.randf_range(-asteroid_speed_range, asteroid_speed_range),rng2.randf_range(-asteroid_speed_range, asteroid_speed_range)))
	
		#change Spawn position
	var nodes = get_tree().get_nodes_in_group("spawn")# selec the spawn group
	var node = nodes[randi() % nodes.size()]# chose a random node in the spawn group
	
	# Set Spawn position to new position
	var position = node.position
	$AsteroidSpawn.position = position
	
	
	var rngT = RandomNumberGenerator.new()
	$AsteroidSpawnRimer.wait_time = rngT.randf_range(2,6) # select random time between 5s and 10s
	
	
	

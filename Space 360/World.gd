extends Node2D

export (int) var asteroid_speed = 5


var Asteroid = preload("res://prototype_asteroid.tscn")
var Enemy = preload("res://enemy_space_ship/enemy_space_ship.tscn")



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
	
	
		#change Spawn position
	var nodes = get_tree().get_nodes_in_group("spawn")# selec the spawn group
	var node = nodes[randi() % nodes.size()]# chose a random node in the spawn group
	
	# Set Spawn position to new position
	var position = node.position
	$AsteroidSpawn.position = position
	
	#$AsteroidSpawnTimer.wait_time = randi() % 5 + 5 # select random time between 5s and 10s
	
	
	

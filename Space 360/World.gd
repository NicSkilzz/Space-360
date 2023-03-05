extends Node2D



var Asteroid = preload("res://Asteroid/Asteroid.tscn")
var Enemy = preload("res://enemy_space_ship/enemy_space_ship_rigid_body.tscn")
onready var asteroid_timer = $AsteroidSpawnRimer
onready var ship_timer = $ShipSpawnTimer



export (float) var asteroid_speed_range = 0.1


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_SpawnTimer_timeout():
	
	#change Spawn position
	var nodes = get_tree().get_nodes_in_group("spawn")# select the spawn group
	var rng3 = RandomNumberGenerator.new()
	rng3.randomize()
	var node = nodes[rng3.randf_range(0.0, nodes.size())]# chose a random node in the spawn group
	
	
	
	var enemy = Enemy.instance()
	add_child(enemy)
	enemy.position = node.position
	
	
	
	var rngT = RandomNumberGenerator.new()
	rngT.randomize()
	ship_timer.wait_time = rngT.randf_range(2,6) # select random time between 5s and 10s

func _on_AsteroidSpawnRimer_timeout():
		#change Spawn position
	var nodes = get_tree().get_nodes_in_group("spawn")# selec the spawn group
	var rng3 = RandomNumberGenerator.new()
	rng3.randomize()
	var node = nodes[rng3.randf_range(0.0, nodes.size())]# chose a random node in the spawn group
	
	
	
	var asteroid = Asteroid.instance()
	add_child(asteroid)
	asteroid.position = node.position
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var rng2 = RandomNumberGenerator.new()
	rng2.randomize()
	asteroid.add_force(Vector2(), Vector2(rng.randf_range(-asteroid_speed_range, asteroid_speed_range),rng2.randf_range(-asteroid_speed_range, asteroid_speed_range)))
	
	
	var rngT = RandomNumberGenerator.new()
	rngT.randomize()
	asteroid_timer.wait_time = rngT.randf_range(2,6) # select random time between 5s and 10s


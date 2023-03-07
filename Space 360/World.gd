extends Node2D



var Asteroid = preload("res://Asteroid/Asteroid.tscn")
var Enemy = preload("res://enemy_space_ship/enemy_space_ship_rigid_body.tscn")
onready var asteroid_timer = $AsteroidSpawnRimer
onready var ship_timer = $ShipSpawnTimer
onready var current_score = $score_board/current_score

export (int) var score = 0
export (int) var end_score = 0
export (float) var asteroid_speed_range = 0.1
export (int) var highscore = 0
const highscore_filepath = "res://highscore.data"

var time_elapsed = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	load_highscore()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time_elapsed += delta


func _on_SpawnTimer_timeout():
	
	#change Spawn position
	var nodes = get_tree().get_nodes_in_group("spawn")# select the spawn group
	var rng3 = RandomNumberGenerator.new()
	rng3.randomize()
	var node = nodes[rng3.randf_range(0.0, nodes.size())]# chose a random node in the spawn group
	
	var enemy = Enemy.instance()
	add_child(enemy)
	enemy.position = node.position
	
	ship_timer.wait_time = 1/((0.001 * time_elapsed) + 0.1) # select time

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
	

	asteroid_timer.wait_time = 1/((0.001 * time_elapsed) + 0.1) # select time

func load_highscore():
	var file = File.new()
	if not file.file_exists(highscore_filepath):
		return
	file.open(highscore_filepath, File.READ)
	highscore = file.get_var(highscore)
	file.close()

func save_highscore():
	if end_score > highscore:
		var file = File.new()
		file.open(highscore_filepath, File.WRITE)
		file.store_var()
		file.close()

func set_highscore(new_value):
	highscore = new_value
	save_highscore()

	if end_score > highscore:
		highscore = end_score

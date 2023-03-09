extends Node2D

var Asteroid = preload("res://Asteroid/Asteroid.tscn")
var Enemy = preload("res://enemy_space_ship/enemy_space_ship_rigid_body.tscn")
onready var asteroid_timer = $AsteroidSpawnRimer
onready var ship_timer = $ShipSpawnTimer
onready var current_score = $score_board/current_score
onready var main_player = $Player

export (int) var score = 0
export (int) var end_score = 0
export (float) var asteroid_speed_range = 0.1
var game_data = {}
const SAVE_FILE = "res://save_file.save"

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

	ship_timer.wait_time = 1/((0.006 * time_elapsed) + 0.1) # select time

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
	var node_x = node.global_position.x
	var node_y = node.global_position.y
	#asteroid.add_force(Vector2(), Vector2(rng.randf_range(-asteroid_speed_range, asteroid_speed_range),rng2.randf_range(-asteroid_speed_range,asteroid_speed_range)))
	var player_position_x = main_player.global_position.x
	var player_position_y = main_player.global_position.y
	#asteroid.add_force(Vector2(),Vector2(rng2.randf_range(-asteroid_speed_range,asteroid_speed_range),0).rotated(atan2(player_position_x - node.global_position.x, player_position_y - node.global_position.y)))
	
	if(node_y <= player_position_y && node_x >= player_position_x):
		asteroid.add_force(Vector2(), Vector2(rng.randf_range(-asteroid_speed_range, 0),rng2.randf_range(0,asteroid_speed_range)))
	elif(node_y <= player_position_y && node_x <= player_position_x):
		asteroid.add_force(Vector2(), Vector2(rng.randf_range(0, asteroid_speed_range),rng2.randf_range(0,asteroid_speed_range)))
	elif(node_y >= player_position_y && node_x >= player_position_x):
		asteroid.add_force(Vector2(), Vector2(rng.randf_range(-asteroid_speed_range, 0),rng2.randf_range(-asteroid_speed_range,0)))
	else:
		asteroid.add_force(Vector2(), Vector2(rng.randf_range(0, asteroid_speed_range),rng2.randf_range(-asteroid_speed_range,0)))
		
		
	asteroid_timer.wait_time = 1/((0.001 * time_elapsed) + 0.1) # select time

func load_highscore():
	var file = File.new()
	if not file.file_exists(SAVE_FILE):
		game_data = {"highscore": 0}
		save_highscore()
	file.open(SAVE_FILE, File.READ)
	game_data = file.get_var()
	file.close()

func save_highscore():
	var file = File.new()
	file.open(SAVE_FILE, File.WRITE)
	file.store_var(game_data)
	file.close()

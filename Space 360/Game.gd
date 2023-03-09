extends Node2D

func _ready():
	GlobalWorld.load_highscore()
	get_tree().change_scene("res://Home Screen/home_screen.tscn")

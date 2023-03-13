extends Node2D

func _ready():
	GlobalWorld.load_highscore()
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://Home Screen/home_screen.tscn")

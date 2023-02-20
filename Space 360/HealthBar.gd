extends Control

onready var health_bar = $health_bar

func _on_Timer_timeout():
	health_bar.value -= 10

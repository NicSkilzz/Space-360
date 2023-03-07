extends CanvasLayer

func _on_play_again_button_pressed():
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://World.tscn")

func _on_quit_button_pressed():
	get_tree().quit()


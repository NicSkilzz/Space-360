extends Label

var save_file = GlobalWorld.game_data

func _ready():
	if save_file.highscore:
		self.text = "Your Highscore: " + str(save_file.highscore)
	else:
		self.text = "Your Highscore: " + str(0)

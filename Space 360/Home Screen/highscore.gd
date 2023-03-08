extends Label

var save_file = GlobalWorld.game_data

func _ready():
	self.text = "Highscore: " + str(save_file.highscore)

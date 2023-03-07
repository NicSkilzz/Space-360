extends Label

func _ready():
	self.text = "Highscore: " + str(GlobalWorld.highscore)


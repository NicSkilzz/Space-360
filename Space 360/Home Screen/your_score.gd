extends Label

func _process(delta):
	self.text = "Your score: " + str(GlobalWorld.highscore)

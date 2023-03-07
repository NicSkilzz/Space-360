extends Label

func _ready():
	self.text = "Your score: " + str(GlobalWorld.end_score)

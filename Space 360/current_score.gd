extends Label


func _process(delta):
	self.text = str(GlobalWorld.score)

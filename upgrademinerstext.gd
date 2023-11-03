extends RichTextLabel

func _ready():
	updateText()

func _process(_delta):
	updateText()
	
func updateText():
	# BBCode string with an image and text
	if self.get_parent() != null:
		text = "Upgrade Miners " + str(self.get_parent().upgrade_miners_cost)
	else:
		print("upgrade cost")

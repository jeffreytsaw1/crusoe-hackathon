extends RichTextLabel

var min_swe = 12

func _ready():
	updateText()
	self.visible = false

func _process(_delta):
	updateText()
	if Global.num_swe < min_swe:
		self.visible = false
	else:
		self.visible = true
	
func updateText():
	# BBCode string with an image and text
	var bbcode_text = "[img=40vw]res://crusoe_logo.png[/img] [color=#000000] Worst: " + str(Global.worst_utility_pad) +" [/color]"
	text = bbcode_text

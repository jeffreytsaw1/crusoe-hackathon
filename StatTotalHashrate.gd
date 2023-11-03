extends RichTextLabel

var min_swe = 5

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
	var bbcode_text = "[img=40vw]res://hashrate.png[/img] [color=#000000] Hash " + str(Global.total_hashrate) +" [/color]"
	text = bbcode_text

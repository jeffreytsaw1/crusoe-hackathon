extends RichTextLabel

var min_swe = 10

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
	var bbcode_text = "[img]res://cloud_up.png[/img] [color=#000000] Active GPUs " + str(Global.active_gpus) +" [/color]"
	text = bbcode_text

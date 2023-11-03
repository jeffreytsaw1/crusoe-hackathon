extends RichTextLabel

func _ready():
	updateText()

func _process(_delta):
	updateText()
	
func updateText():
	# BBCode string with an image and text
	var bbcode_text = "[img]res://cloud_up.png[/img] [color=#000000] Hash capacity " + str(Global.total_hashrate_capacity) +" [/color]"
	text = bbcode_text

extends RichTextLabel

func _ready():
	updateText()

func _process(_delta):
	updateText()
	
func updateText():
	# BBCode string with an image and text
	var bbcode_text = "[img]res://cloud_up.png[/img] [color=#ffbb22] Hashy " + str(Global.num_swe) +" [/color]"
	text = bbcode_text

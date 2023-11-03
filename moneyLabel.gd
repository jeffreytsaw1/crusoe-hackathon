extends RichTextLabel

func _ready():
	# BBCode string with an image and text
	var bbcode_text = "[img]res://cloud_up.png[/img] [color=#ffbb22] Money " + str(Global.money) +" [/color]"
	text = bbcode_text

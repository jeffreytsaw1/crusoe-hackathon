extends RichTextLabel

func _ready():
	# BBCode string with an image and text
	var bbcode_text = "[img]res://cloud_down.png[/img] [color=#ADD8E6]Mechanics " + str(Global.num_mechanics) + "[/color]"
	text = bbcode_text
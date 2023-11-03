extends RichTextLabel

func _ready():
	updateText()

func _process(_delta):
	updateText()
	
func updateText():
	# BBCode string with an image and text
	var bbcode_text = "[img=40vw]res://cloud.png[/img] [color=#000000] Cloud Boxes " + str(Global.cloud_boxes) +" [/color]"
	text = bbcode_text

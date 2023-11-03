extends RichTextLabel

func _ready():
	updateText()

func _process(_delta):
	updateText()
	
func updateText():
	# BBCode string with an image and text
	var bbcode_text = "[img]res://cloud_up.png[/img] [color=#000000] Capacity GPUs " + str(Global.gpu_capacity) +" [/color]"
	text = bbcode_text

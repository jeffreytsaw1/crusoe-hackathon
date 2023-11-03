extends RichTextLabel

func _ready():
	update()
	
func _process(_delta):
	update()
	
func update():
	# BBCode string with an image and text
	var bbcode_text = "[img]res://cloud_up.png[/img][color=#bc544b] SWEs " + str(Global.num_swe) + "[/color]"
	text = bbcode_text

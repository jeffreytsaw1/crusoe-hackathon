extends RichTextLabel

func _ready():
	# BBCode string with an image and text
	var bbcode_text = "[img]res://cloud_up.png[/img][color=#bc544b] SWEs " + str(Global.num_swe) + "[/color]"
	text = bbcode_text

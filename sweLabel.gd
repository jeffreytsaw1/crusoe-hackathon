extends RichTextLabel

func _ready():
	update()
	
func _process(_delta):
	update()
	
func update():
	# BBCode string with an image and text
	var bbcode_text = "[img=40vw]res://chicken.png[/img][color=#f7b4bb] SWEs " + str(Global.num_swe) + "[/color]"
	text = bbcode_text

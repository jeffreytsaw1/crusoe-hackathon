extends RichTextLabel

func _ready():
	update()
	
func _process(_delta):
	update()

func update():
	var bbcode_text = "[img=40vw]res://nick.png[/img] [color=#ADD8E6]Mechanics " + str(Global.num_mechanics) + "[/color]"
	text = bbcode_text

extends RichTextLabel

func _ready():
	update()

func _process(_delta):
	update()

func update():
	var bbcode_text = "[img]res://cloud_up.png[/img] [color=#ffbb22] Documents " + str(Global.documents) +" [/color]"
	self.text = bbcode_text

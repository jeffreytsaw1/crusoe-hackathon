extends RichTextLabel

func _ready():
	update()

func _process(_delta):
	update()

func update():
	var bbcode_text = "[img=40vw]res://documents.png[/img] [color=#000000] Documents " + str(Global.documents) +" [/color]"
	self.text = bbcode_text

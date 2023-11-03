extends RichTextLabel

func _ready():
	update()

func _process(_delta):
	update()

func update():
	var bbcode_text = "[img=40vw]res://coin.png[/img] [color=#ffbb22] Money " + str(Global.money) +" [/color]"
	text = bbcode_text

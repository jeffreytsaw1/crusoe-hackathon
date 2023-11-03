extends ColorRect


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func updateNickButton(n, m):
	if n==m:
		$buynick.text = "You've maxed out on Nicks " + "(" + str(n) +"/" + str(m) +")"
	else :
		$buynick.text = "'Enter' to buy Nick (" + str(n) +"/" + str(m) +")"

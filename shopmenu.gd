extends StaticBody2D


var pad_owned = false

var price = 100 # adjust based on thing
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _physics_process(delta):
	# coin logic
	$buybuttoncolour.color = "5ea01d"


func _on_buybutton_pressed():
	print("buy")
	if pad_owned == false:
		pad_owned = true
		self.visible = false
	#coin logic here



extends StaticBody2D


var pad_owned = false
var pad_name = ""
var number_of_boxes = 1
var base_price = 50

var price = 100 # adjust based on thing
# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$padname.text = pad_name
	$numboxes.text = str(number_of_boxes)
	
func _physics_process(delta):
	# coin logicpa
	$buybuttoncolour.color = "5ea01d"
	price = base_price * number_of_boxes
	$price.text = str(price)


func _on_buybutton_pressed():
	print("buy")
	if pad_owned == false:
		pad_owned = true
		self.visible = false
	#coin logic here




func _on_subtract_pressed():
	if number_of_boxes > 1:
		number_of_boxes -= 1


func _on_add_pressed():
	if number_of_boxes < 36:
		number_of_boxes += 1
	

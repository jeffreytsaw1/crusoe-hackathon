extends StaticBody2D


var pad_owned = false
var pad_name = ""
var number_of_crypto_boxes = 1
var number_of_cloud_boxes = 1
var base_price_crypto = 50
var base_price_cloud = 75

signal buy_button_pressed

var price = 100 # adjust based on thing
# Called when the node enters the scene tree for the first time.
func _ready():
	pad_name = self.get_parent().get_parent().name


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$padname.text = pad_name
	$numcryptoboxes.text = str(number_of_crypto_boxes)
	$numcloudboxes.text = str(number_of_cloud_boxes)
	
func _physics_process(delta):
	if Global.money > price: 
		$buybuttoncolour.color = "5ea01d"
	else:
		$buybuttoncolour.color = "b2201a"
	price = (base_price_crypto * number_of_crypto_boxes + 
		base_price_cloud * number_of_cloud_boxes)
	$price.text = str(price)


func _on_buybutton_pressed():
	if Global.money >= price and pad_owned == false:
		pad_owned = true
		Global.money -= price
		self.visible = false
		buy_button_pressed.emit()

func _on_add_pressed():
	if number_of_crypto_boxes < 36:
		number_of_crypto_boxes += 1
	

func _on_subtractcloud_pressed():
	if number_of_cloud_boxes > 1:
		number_of_cloud_boxes -= 1


func _on_addcloud_pressed():
	if number_of_cloud_boxes < 10:
		number_of_cloud_boxes += 1


func _on_subtractcrypto_pressed():
	if number_of_crypto_boxes > 1:
		number_of_crypto_boxes -=1


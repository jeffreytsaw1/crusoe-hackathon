extends Control

func _ready():
	pass
	# Set the initial position of the Control node at the bottom of the viewport
	var sizeInventory = 100 # TODO follow actual size
	position.y = get_viewport_rect().size.y - sizeInventory
	position.x = 0
	position.y = 0
	
# Connect this script to signals or add logic as needed

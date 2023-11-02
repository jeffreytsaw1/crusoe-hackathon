extends StaticBody2D

var pad_owned = false

# Called when the node enters the scene tree for the first time.
func _ready():
	$shopmenu.buy_button_pressed.connect(renderStats)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pad_owned = $shopmenu.pad_owned

func renderStats():
	$shopmenu.visible = false
	$statsandactions.visible = true

func render():
	if pad_owned:
		$shopmenu.visible = false
		$statsandactions.visible = true
	else:
		$shopmenu.visible = true
		$statsandactions.visible = false
		
func unrender():
	$shopmenu.visible = false
	$statsandactions.visible = false
	


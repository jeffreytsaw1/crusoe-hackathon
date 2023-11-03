extends StaticBody2D

const min_money = 1000
var failed_ipo = false

func attempt_ipo():
	if Global.money >= min_money:
		Global.IPO = true
	else:
		failed_ipo = true
		$AttemptIPOControl.visible = false
		$FailedLabel.visible = true
		$FailedLabel.text = "[center]You need $" + str(min_money) + "[/center]"
		

# Called when the node enters the scene tree for the first time.
func _ready():
	$AttemptIPOControl.visible = false
	$WinLabel.visible = false
	$FailedLabel.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Global.IPO:
		$AttemptIPOControl.visible = false
		$WinLabel.visible = true
	pass

func _on_area_2d_body_entered(body):
	if !Global.IPO:
		$AttemptIPOControl.visible = true


func _on_area_2d_body_exited(body):
	$AttemptIPOControl.visible = false
	$FailedLabel.visible = false


func _on_ipo_button_pressed():
	attempt_ipo()

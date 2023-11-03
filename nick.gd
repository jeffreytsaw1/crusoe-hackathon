extends StaticBody2D

var num_mechanics = 0
var mechanics_cost = 145
var max_mechanics = 2
var interactable_body = null
var pad_owned = false
# Called when the node enters the scene tree for the first time.
func _ready():
	$sign.visible = false
	self.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pad_owned = self.get_parent().pad_owned
	if pad_owned and num_mechanics < 2:
		self.visible = true
	else:
		self.visible = false
		


func _input(event):
	if interactable_body != null:
		if (event.is_action_pressed("ui_accept") and 
		Global.money >= mechanics_cost):
			Global.money -= mechanics_cost
			num_mechanics += 1
			Global.num_mechanics += 1
			$sign.updateNickButton(num_mechanics, max_mechanics)


func _on_area_2d_body_entered(body):
	if body.has_method("player_pad_method"):
		if num_mechanics < max_mechanics:
			$sign.visible = true
			interactable_body = body


func _on_area_2d_body_exited(body):
	$sign.visible = false
	interactable_body = null

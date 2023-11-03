extends StaticBody2D

var pms_cost = 350
var interactable_body = null

# Called when the node enters the scene tree for the first time.
func _ready():
	interactable_body = null


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	

func _input(event):
	if interactable_body != null:
		if event.is_action_pressed("ui_accept") and Global.money > pms_cost:
			Global.num_pms += 1
			Global.money -= pms_cost


func _on_area_2d_body_entered(body):
	if body.has_method("player_pad_method"):
		interactable_body = body

func _on_area_2d_body_exited(body):
	if body.has_method("player_pad_method"):
		interactable_body = null

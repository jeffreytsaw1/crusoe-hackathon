extends StaticBody2D

var interactable_body = null
var swe_cost = 45
var max_swes = 10

# Called when the node enters the scene tree for the first time.
func _ready():
	$sign.visible = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _input(event):
	if interactable_body != null:
		if event.is_action_pressed("ui_accept") and Global.money > swe_cost:
			Global.num_swe += 1
			Global.money -= swe_cost


func _on_area_2d_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	if body.has_method("player_pad_method"):
		$sign.visible = true
		interactable_body = body


func _on_area_2d_body_shape_exited(body_rid, body, body_shape_index, local_shape_index):
	if body.has_method("player_pad_method"):
		interactable_body = null

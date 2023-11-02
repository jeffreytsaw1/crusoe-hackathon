extends StaticBody2D

func _ready():
	$shopmenu.visible = false

func _on_area_2d_body_entered(body):
	if body.has_method("player_pad_method"):
		if $shopmenu.pad_owned == true:
			$shopmenu.visible = false
		else:
			$shopmenu.visible = true


func _on_area_2d_body_exited(body):
	$shopmenu.visible = false

extends StaticBody2D

var pad_owned = false

func _ready():
	#$shopmenu.$padname = self.name
	$menu.unrender()

func _process(delta):
	pad_owned = $menu.pad_owned
	

func _on_area_2d_body_entered(body):
	if body.has_method("player_pad_method"):
		$menu.render()


func _on_area_2d_body_exited(body):
	$menu.unrender()

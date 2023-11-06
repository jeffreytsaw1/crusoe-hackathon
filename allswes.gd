extends StaticBody2D

var interactable_body = null
var swe_happiness = 100
var gameTick = Time.get_unix_time_from_system() + 1

# Called when the node enters the scene tree for the first time.
func _ready():
	gameTick = Time.get_unix_time_from_system() + 1
	var swes = 0
	for child in $swecontainer.get_children():
		if swes < Global.num_swe:
			child.visible = true
		child.visible = false
		swes += 1



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta): 
	if Time.get_unix_time_from_system() >= gameTick:
		var swes = 0
		for child in $swecontainer.get_children():
			if swes < Global.num_swe:
				child.visible = true
			else:
				child.visible = false
			swes += 1
			
		$swehappiness.text = str(swe_happiness)
		
		if swe_happiness == 0 && Global.num_swe > 0:
			Global.num_swe -= 1
		else:
			swe_happiness -= 0.5
		
		gameTick = Time.get_unix_time_from_system() + 1
	
		

func _input(event):
	if interactable_body != null:
		if event.is_action_pressed("ui_accept"):
			swe_happiness = 100


func _on_sweaccess_body_entered(body):
	if body.has_method("player_pad_method"):
		interactable_body = body


func _on_sweaccess_body_exited(body):
	if body.has_method("player_pad_method"):
			interactable_body = null

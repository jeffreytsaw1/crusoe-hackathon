extends StaticBody2D

const upgrade_miners_cost = 100
const maintenance_cost = 100
const fix_cost = 100

var upgrade_action = false
var maintenance_action = false
var fix_action = false
var check_action = false

var hashrate = 0
var active_gpus = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$hashratevalue.text = str(hashrate)
	$clouduptime.text = str(active_gpus)


func _on_upgrademiners_pressed():
	if Global.money > upgrade_miners_cost:
		Global.money -= upgrade_miners_cost
		upgrade_action = true
		


func _on_maintenance_pressed():
	if Global.money > maintenance_cost:
		Global.money -= maintenance_cost
		maintenance_action = true


func _on_fix_pressed():
	if Global.money > fix_cost:
		Global.money -= fix_cost
		fix_action = true


func _on_check_pressed():
	pass # Replace with function body.

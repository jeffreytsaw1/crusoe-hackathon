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

signal fix_action_taken
signal maintenance_action_taken
signal upgrade_action_taken
signal check_taken


# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	hashrate = self.get_parent().get_parent().hashrate
	$hashratevalue.text = str(hashrate)
	$clouduptimevalue.text = str(active_gpus)
	$name.text = self.get_parent().get_parent().name


func _on_upgrademiners_pressed():
	if Global.money > upgrade_miners_cost:
		Global.money -= upgrade_miners_cost
		upgrade_action = true
		upgrade_action_taken.emit()
		


func _on_maintenance_pressed():
	if Global.money > maintenance_cost:
		Global.money -= maintenance_cost
		maintenance_action = true
		maintenance_action_taken.emit()
		


func _on_fix_pressed():
	if Global.money > fix_cost:
		Global.money -= fix_cost
		fix_action = true
		fix_action_taken.emit()


func _on_check_pressed():
	pass # Replace with function body.

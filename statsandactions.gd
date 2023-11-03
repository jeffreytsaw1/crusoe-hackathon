extends StaticBody2D

var upgrade_miners_cost = 100
var next_upgrade_name = ""
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
	hashrate = max(0, self.get_parent().get_parent().hashrate)
	$hashratevalue.text = str(hashrate)
	active_gpus = max(0, self.get_parent().get_parent().active_gpus)
	$clouduptimevalue.text = str(active_gpus)
	$upgrademinerstext.text = "Upgrade " + str(next_upgrade_name) + "					"+ str(upgrade_miners_cost)
	$name.text = self.get_parent().get_parent().name # TODO i dunno why this is breaking


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
	check_taken.emit()

extends StaticBody2D

var pad_owned = false
var interactable_body = null
var hashrate_per_box = 10
var timer
	
const probability_bitcoin_per_TH = .0001

const events = {
	"snow_storm": {"domain": "pad", "probability": .1, "multiplier": .25},
	"internet_outage": {"domain": "pad", "probability": .1, "multiplier": 0},
	"box_on_fire": {"domain": "box", "probability": .01, "multiplier": 0},
	"broken_louvers": {"domain": "box", "probability": .01, "multiplier": .75},
	"miner_disconnect": {"domain": "crypto", "probability": .1, "multiplier": .5},
	"ssh_failure": {"domain": "cloud", "probability": .1, "multiplier": .35},
	"lightbits_failure": {"domain": "cloud", "probability": .1, "multiplier": .4},
	"vm_died": {"domain": "cloud", "probability": .075, "multiplier": .25},
	"on_diesel": {"domain": "check_cloud", "probability": .5, "multiplier": 1},
	"hvac_failure": {"domain": "check_cloud", "probability": .5, "multiplier": 1}
}

# defaults
var hashrate_capacity = 0
var gpu_capacity = 0
# based on upgrade state
var hashrate = 0
var active_gpus = 0

# pad state
var num_crypto_boxes = 0
var num_cloud_boxes = 0

var next_time_of_failure = 0 # for cloud boxes
var cloud_failure_reason = ""
var events_occurred = [] # maintain list of events that have occurred

var bitcoins = 0

var is_being_fixed = false
var end_maintenance_time

# fixes incur total downtime. time increases exponentially with missing capacity.
# TODO do downtime divided by boxes
func action_start_fix():
	is_being_fixed = true
	hashrate = 0
	active_gpus = 0
	
	var cloud_fix_time = 7*pow(gpu_capacity-active_gpus,3)
	var crypto_fix_time = 1.4*pow((hashrate_capacity-hashrate)/4,2)
	
	end_maintenance_time = Time.get_unix_time_from_system() + crypto_fix_time + cloud_fix_time
	
func process_end_fix():
	if end_maintenance_time == 0:
		return
		
	if Time.get_unix_time_from_system() > end_maintenance_time:
		end_fix()
		
func end_fix():
	hashrate = hashrate_capacity
	active_gpus = gpu_capacity
	is_being_fixed = false
	end_maintenance_time = 0

func process_mine_bitcoin():
	if randf() < probability_bitcoin_per_TH*hashrate:
		bitcoins += 1

func action_collect_bitcoin():
	Global.money +=  bitcoins * Global.bitcoin_price
	bitcoins = 0
	print(Global.money)

func reset_next_time_of_failure():
	next_time_of_failure = 0

func check():
	return next_time_of_failure != 0

func process_induce_cloud_failure_if_needed():
	if next_time_of_failure > Time.get_unix_time_from_system():
		active_gpus = 0

func pad_effect(multiplier):
	hashrate = hashrate * multiplier

func box_effect(multiplier, box_type):
	match box_type:
		"crypto":
			hashrate = hashrate - (multiplier / num_crypto_boxes)
		"cloud":
			hashrate = hashrate - (multiplier / num_cloud_boxes)
		"box":
			hashrate = hashrate - (multiplier / (num_crypto_boxes + num_crypto_boxes))
			
func delayed_cloud_effect():
	if next_time_of_failure == 0:
		next_time_of_failure = Time.get_unix_time_from_system() + 300; # 5 minutes from now

func process_update_events():
	for event_key in events:
		# process per domain type n times
		var iterations = 1
		if events[event_key]["domain"] == "crypto":
			iterations = num_crypto_boxes
		if events[event_key]["domain"] == "cloud":
			iterations = num_cloud_boxes
		if events[event_key]["domain"] == "box":
			iterations = num_crypto_boxes + num_cloud_boxes
		# run probabilities
		for i in iterations:
			var event_occurred = randf() < events[event_key]["probability"]
			events_occurred.append(event_key)
			if event_occurred:
				if events[event_key]["domain"] == "pad":
					pad_effect(events[event_key]["multiplier"])
				elif events[event_key]["domain"] == "check_cloud":
					cloud_failure_reason = event_key
					delayed_cloud_effect()
				else:
					box_effect(events[event_key]["multiplier"], events[event_key]["domain"])	

# possible upgrades
var crypto_upgrades = [{"name": "stock", "state": true, "multiplier": 1, "cost_per_box":0},
	{"name": "jPros", "state": true, "multiplier": 1.07, "cost_per_box": 100},
	{"name": "braiins", "state": true, "multiplier": 1.08, "cost_per_box": 75}]

# We aren't really using this right now
const base_power_efficiency = 40 #J/TH
var power_efficiency = 0
const power_cost_upper_bound = .01 # $/J
const power_cost_lower_bound = .001 # $/J
var rng = RandomNumberGenerator.new()
var power_cost = rng.randf_range(power_cost_lower_bound,power_cost_upper_bound)
func updatePowerEfficiency(amt):
	power_efficiency *= amt
	
func notImplemented():
	pass
	
func boughtPad():
	num_crypto_boxes = $menu.get_node("shopmenu").number_of_crypto_boxes
	num_cloud_boxes = $menu.get_node("shopmenu").number_of_cloud_boxes
	hashrate_capacity = num_crypto_boxes * hashrate_per_box
	hashrate = hashrate_capacity

func _on_timer_timeout():
	if !is_being_fixed:
		process_update_events()
		process_induce_cloud_failure_if_needed()
	else:
		process_end_fix()


# IMPORTANT GAME FUNCTIONS BUILT IN

func _ready():
	$menu.unrender()
	$menu.get_node("statsandactions").upgrade_action_taken.connect(action_start_fix)
	$menu.get_node("statsandactions").maintenance_action_taken.connect(notImplemented)
	$menu.get_node("statsandactions").fix_action_taken.connect(action_start_fix)
	$menu.get_node("statsandactions").check_taken.connect(notImplemented)
	$menu.get_node("shopmenu").buy_button_pressed.connect(boughtPad)
	
	timer = Timer.new()
	timer.wait_time = 1.0
	timer.autostart = true
	timer.start()
	
	timer.timeout.connect(_on_timer_timeout)
	
func _process(delta):
	pad_owned = $menu.pad_owned
	if bitcoins > 0:
		$bitcoin.visible = true
	else:
		$bitcoin.visible = false
	process_mine_bitcoin()

func _on_area_2d_body_entered(body):
	if body.has_method("player_pad_method"):
		$menu.render()
		interactable_body = body

func _on_area_2d_body_exited(body):
	$menu.unrender()
	interactable_body = null
	
func _input(event):
	if interactable_body != null:
		if event.is_action_pressed("ui_accept"):
			action_collect_bitcoin()
			$bitcoin.visible = false

extends StaticBody2D

var pad_owned = false
var interactable_body = null
var hashrate_per_box = 10
var timer
var active_gpus_per_box = 10
var num_mechanics = 0

var event_counter = 20 # every 20 game tickets run events
	
const probability_bitcoin_per_TH = .0001

const events = {
	"snow_storm": {"domain": "pad", "probability": .00075, "multiplier": .85},
	"internet_outage": {"domain": "pad", "probability": .0005, "multiplier": 0.5},
	"box_on_fire": {"domain": "box", "probability": .00001, "multiplier": 0},
	"broken_louvers": {"domain": "box", "probability": .0015, "multiplier": .9},
	"miner_disconnect": {"domain": "crypto", "probability": .001, "multiplier": .8},
	"psu_failure": {"domain": "crypto", "probability": .005, "multiplier": .9},
	"ssh_failure": {"domain": "cloud", "probability": .001, "multiplier": .35},
	"lightbits_failure": {"domain": "cloud", "probability": .001, "multiplier": .4},
	"vm_died": {"domain": "cloud", "probability": .0075, "multiplier": .25},
	"on_diesel": {"domain": "check_cloud", "probability": .0002, "multiplier": 1},
	"hvac_failure": {"domain": "check_cloud", "probability": .0001, "multiplier": 1}
}

# defaults
var base_hashrate_capacity = 0
var hashrate_capacity = 0
var gpu_capacity = 0
# based on upgrade state
var hashrate = 0
var active_gpus = 0

# pad state
var num_crypto_boxes = 0
var num_cloud_boxes = 0

var last_check = Time.get_unix_time_from_system()
var next_time_of_failure = 0 # for cloud boxes
var cloud_failure_reason = ""
var events_occurred = [] # maintain list of events that have occurred

var bitcoins = 0

var is_being_fixed = false
var end_maintenance_time = 0

var gameTick = Time.get_unix_time_from_system() + 1

var check_cloud_box_increment = 40

# fixes incur total downtime. time increases exponentially with missing capacity.
func action_start_fix():
	events_occurred = []
	is_being_fixed = true
	hashrate = 0
	active_gpus = 0
	
	var cloud_fix_time = 1.7*pow((gpu_capacity-active_gpus)/20,3)
	var crypto_fix_time = 1.4*pow((hashrate_capacity-hashrate)/10,2)
	if num_mechanics >= 1:
		cloud_fix_time *= 0.85
		crypto_fix_time *= 0.85
	print("fix time: ", crypto_fix_time + cloud_fix_time)
	end_maintenance_time = Time.get_unix_time_from_system() + crypto_fix_time + cloud_fix_time
	
func process_end_fix():
	if end_maintenance_time == 0:
		return
	
	next_time_of_failure = Time.get_unix_time_from_system() + check_cloud_box_increment
		
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
		
func process_cloud_revenue():
	Global.money += 0.7 * active_gpus

func action_collect_bitcoin():
	Global.money +=  bitcoins * Global.bitcoin_price
	bitcoins = 0

func action_check():
	last_check = Time.get_unix_time_from_system()
	reset_next_time_of_failure()

func reset_next_time_of_failure():
	next_time_of_failure = 0

func process_induce_cloud_failure_if_needed():
	if next_time_of_failure == 0:
		next_time_of_failure = Time.get_unix_time_from_system() + check_cloud_box_increment
	if next_time_of_failure < Time.get_unix_time_from_system():
		active_gpus = 0

func pad_effect(multiplier):
	hashrate = hashrate * multiplier

func box_effect(multiplier, box_type):
	match box_type:
		"crypto":
			if hashrate > 0:
				hashrate = hashrate - hashrate * ((1.0-multiplier) / num_crypto_boxes)
		"cloud":
			if active_gpus > 0:
				active_gpus = active_gpus - active_gpus * ((1.0-multiplier) / num_cloud_boxes)
		"box":
			if hashrate > 0:
				hashrate = hashrate - hashrate * ((1.0-multiplier) / (num_crypto_boxes + num_crypto_boxes))
			
func delayed_cloud_effect():
	if next_time_of_failure == 0:
		next_time_of_failure = Time.get_unix_time_from_system() + check_cloud_box_increment; # 40s from now

func process_update_events():
	# prevent events during fix
	if is_being_fixed:
		return
		
	# upgrade event counter
	event_counter -= 1
	if event_counter == 0:
		event_counter = 20
	else :
		return
	# process all possible events
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
			var probability = events[event_key]["probability"]
			if num_mechanics == 2:
				probability *= 0.85
			var event_occurred = randf() < probability
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
var crypto_upgrades = [
	{"name": "stock", "state": true, "multiplier": 1, "cost_per_box":0},
	{"name": "jPros", "state": false, "multiplier": 1.07, "cost_per_box": 80},
	{"name": "XPs", "state": false, "multiplier": 1.07, "cost_per_box": 70},
	{"name": "braiins", "state": false, "multiplier": 1.05, "cost_per_box": 50}
]

func action_attempt_perform_upgrade():
	var i = get_next_crypto_upgrade_index()
	if i == -1:
		return false
		
	if Global.money - get_next_upgrade_total_cost() < 0:
		return false
	
	Global.money -= get_next_upgrade_total_cost()
	crypto_upgrades[i]["state"] = true
	base_hashrate_capacity *= crypto_upgrades[i]["multiplier"]
	updateHashrateCapacity()
	hashrate = hashrate_capacity
	return true
	
func updateHashrateCapacity():
	if Global.num_swe < 2:
		hashrate_capacity = base_hashrate_capacity * .9
	else:
		hashrate_capacity = base_hashrate_capacity * (Global.num_swe-1)*1.01

func get_next_crypto_upgrade_index():
	for i in len(crypto_upgrades):
		if crypto_upgrades[i]["state"] == false:
			return i
	return -1
	
func get_next_upgrade_total_cost():
	var i = get_next_crypto_upgrade_index()
	if i == -1:
		return 0
	return crypto_upgrades[i]["cost_per_box"]*num_crypto_boxes

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
	base_hashrate_capacity = num_crypto_boxes * hashrate_per_box
	updateHashrateCapacity()
	hashrate = hashrate_capacity
	gpu_capacity = num_cloud_boxes * active_gpus_per_box
	active_gpus = gpu_capacity
	if gpu_capacity > 0:
		next_time_of_failure = Time.get_unix_time_from_system() + check_cloud_box_increment
		
	
	

func _on_timer_timeout():
	if !is_being_fixed:
		process_update_events()


# IMPORTANT GAME FUNCTIONS BUILT IN

func _ready():
	$menu.unrender()
	$menu.get_node("statsandactions").upgrade_action_taken.connect(action_attempt_perform_upgrade)
	$menu.get_node("statsandactions").maintenance_action_taken.connect(notImplemented)
	$menu.get_node("statsandactions").fix_action_taken.connect(action_start_fix)
	$menu.get_node("statsandactions").check_taken.connect(action_check)
	$menu.get_node("shopmenu").buy_button_pressed.connect(boughtPad)
	$AdvancedStats.visible = false
	set_process_input(true)
	
	
	
	
	
func _process(delta):
	pad_owned = $menu.pad_owned
	num_mechanics = $nick.num_mechanics 
	
	if bitcoins > 0:
		$bitcoin.visible = true
	else:
		$bitcoin.visible = false
	if Time.get_unix_time_from_system() >= gameTick:
		process_mine_bitcoin()
		process_induce_cloud_failure_if_needed()
		process_cloud_revenue()
		process_end_fix()
		_on_timer_timeout()
		$menu.get_node("statsandactions").upgrade_miners_cost = get_next_upgrade_total_cost()
		
		var next_index = get_next_crypto_upgrade_index()
		if next_index == -1:
			$menu.get_node("statsandactions").next_upgrade_name = "None"
		else:
			$menu.get_node("statsandactions").next_upgrade_name = crypto_upgrades[next_index]["name"]

		gameTick = Time.get_unix_time_from_system() + 1
	sendAdvancedStatsToChild()
		

func _on_area_2d_body_entered(body):
	if body.has_method("player_pad_method"):
		if not pad_owned:
			$menu.render()
		interactable_body = body

func _on_area_2d_body_exited(body):
	$menu.unrender()
	$AdvancedStats.visible = false
	interactable_body = null
	
func _input(event):
	if interactable_body != null:
		if event.is_action_pressed("ui_accept"):
			action_collect_bitcoin()
			$bitcoin.visible = false
		if event.is_action_pressed("ui_text_backspace"):
			$menu.render()
		if event.is_action_pressed("ui_text_indent"):
			$AdvancedStats.visible = !$AdvancedStats.visible











# STATS

func sendAdvancedStatsToChild():
	$AdvancedStats.hashrate_utility = calcHashrateUtility()
	$AdvancedStats.gpu_utility = calcGPUUtility()
	$AdvancedStats.most_recent_event = mostRecentEvent()
	$AdvancedStats.time_till_fixed = timeTillFixed()
	$AdvancedStats.cloud_check = sinceLastCheck()
	$AdvancedStats.total_event_prob = calcEventsTotalProb()

func calcHashrateUtility():
	if hashrate_capacity ==0:
		return 0
	return snapped(hashrate/hashrate_capacity, .01)
	
func calcGPUUtility():
	if gpu_capacity ==0:
		return 0
	return snapped(active_gpus/gpu_capacity, .01)
	
func mostRecentEvent():
	if len(events_occurred) == 0:
		return "None"
	return events_occurred[len(events_occurred)-1]
	
func timeTillFixed():
	var diffTime = snapped(end_maintenance_time-Time.get_unix_time_from_system(), 1)
	if diffTime > 0:
		return diffTime
	else:
		return 0

func sinceLastCheck():
	return snapped(Time.get_unix_time_from_system() - last_check, 0)
	
func calcEventsTotalProb():
	var total_prob = 0
	for event_key in events:
		total_prob += events[event_key]["probability"]
	return total_prob

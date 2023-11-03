extends VBoxContainer

var hashrate_utility = 0
var gpu_utility = 0
var most_recent_event = "None"
var cloud_check = 0
var time_till_fixed = 0
var total_event_prob = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$CryptoUtilityPad.text = "Crypto Utility: " + str(hashrate_utility)
	$GPUUtilityPad.text = "GPU Utility: " + str(gpu_utility)
	$MostRecentEventPad.text = "Recent Event: " + most_recent_event
	$CloudCheckTimerPad.text = "Checked " + str(cloud_check) + "s ago"
	$FixTimerPad.text = "Fixed in " + str(time_till_fixed) + "s"
	$TotalEventProb.text = "Risk indicator: " + str(total_event_prob)

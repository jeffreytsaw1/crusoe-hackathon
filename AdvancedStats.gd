extends Node


var hashrate_utility = 0
var gpu_utility = 0
var most_recent_event = "None"
var cloud_check = 0
var time_till_fixed = 0
var total_event_prob = 0
	
# Called when the node enters the scene tree for the first time.
func _ready():
	update()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	update()
	
func update():
	$AdvancedStatsContainer.hashrate_utility = hashrate_utility
	$AdvancedStatsContainer.gpu_utility = gpu_utility
	$AdvancedStatsContainer.most_recent_event = most_recent_event
	$AdvancedStatsContainer.time_till_fixed = time_till_fixed
	$AdvancedStatsContainer.cloud_check = cloud_check
	$AdvancedStatsContainer.total_event_prob = total_event_prob

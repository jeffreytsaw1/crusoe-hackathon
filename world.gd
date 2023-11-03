extends Node2D

var last_bitcoin_update = Time.get_unix_time_from_system()
var documentTick = Time.get_unix_time_from_system() + 10

func clamp(num, mi, ma):
	if num < mi:
		return mi
	if num > ma :
		return ma
	return num
		
func _process(delta):
	# get documents every 10 seconds
	if Time.get_unix_time_from_system() > documentTick:
		Global.documents += Global.num_pms * 1
		documentTick = Time.get_unix_time_from_system() + 10
		
	if Time.get_unix_time_from_system() - last_bitcoin_update > 60: # update every minute
		var noise = Global.bitcoin_price/100
		Global.bitcoin_price += randf() * noise - noise/2 # permute bitcoin price
		Global.bitcoin_price = clamp(Global.bitcoin_price,0, 2*Global.bitcoin_price)
		last_bitcoin_update = Time.get_unix_time_from_system()
	
	Global.money = snapped(Global.money, .1)
	
	Global.total_hashrate = 0
	Global.total_hashrate += $Altuve.hashrate
	Global.total_hashrate += $BrownBear.hashrate
	Global.total_hashrate = snapped(Global.total_hashrate, .1)
	
	Global.total_hashrate_capacity = 0
	Global.total_hashrate_capacity += $Altuve.hashrate_capacity
	Global.total_hashrate_capacity += $BrownBear.hashrate_capacity
	Global.total_hashrate_capacity = snapped(Global.total_hashrate_capacity, .1)
	
	Global.crypto_boxes = 0
	Global.crypto_boxes += $Altuve.num_crypto_boxes
	Global.crypto_boxes += $BrownBear.num_crypto_boxes
	
	Global.cloud_boxes = 0
	Global.cloud_boxes += $Altuve.num_cloud_boxes
	Global.cloud_boxes += $BrownBear.num_cloud_boxes
	
	Global.active_gpus = 0
	Global.active_gpus += $Altuve.active_gpus
	Global.active_gpus += $BrownBear.active_gpus
	Global.active_gpus = snapped(Global.active_gpus, .1)
	
	Global.gpu_capacity = 0
	Global.gpu_capacity += $Altuve.gpu_capacity
	Global.gpu_capacity += $BrownBear.gpu_capacity
	Global.gpu_capacity = snapped(Global.gpu_capacity, .1)

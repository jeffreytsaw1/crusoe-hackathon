extends Node2D

var last_bitcoin_update = Time.get_unix_time_from_system()

func clamp(num, mi, ma):
	if num < mi:
		return mi
	if num > ma :
		return ma
	return num
		
func _process(delta):
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

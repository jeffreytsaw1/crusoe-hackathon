extends Node2D

var last_bitcoin_update = Time.get_unix_time_from_system()

func _process(delta):
	if Time.get_unix_time_from_system() - last_bitcoin_update > 60: # update every minute
		var noise = 5000.0
		Global.bitcoin_price += randf() * noise - noise/2 # permute bitcoin price
		last_bitcoin_update = Time.get_unix_time_from_system()

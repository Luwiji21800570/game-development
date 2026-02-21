extends Node2D

var coins_collected = 0

func _ready():
	$Portal.visible = false


func add_coin():
	coins_collected += 1
	print("Coins collected:", coins_collected)

	if coins_collected >= 5:
		$Portal.visible = true
		print("Portal unlocked!")

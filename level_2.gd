extends Node2D

var coins_collected = 0

@onready var player := $Player
@onready var spawn_point := $SpawnPoint

func add_coin():
	coins_collected += 1
	print("Coins collected:", coins_collected)
	if coins_collected >= 5:
		$Portal.visible = true
		print("Portal unlocked!")

func _process(_delta):
	if player.global_position.y > 1000:  # adjust if needed
		player.global_position = spawn_point.global_position
		player.velocity = Vector2.ZERO

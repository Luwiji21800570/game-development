extends Area2D

var collected = false

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if collected:
		return
	if body.name == "Player":
		collected = true
		get_parent().add_coin()
		queue_free()

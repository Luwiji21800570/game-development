extends Area2D

@export var speed: float = 300.0
var direction = Vector2.ZERO

func _process(delta):
	# Move in the assigned direction
	position += direction * speed * delta
	# Remove bullet if outside viewport
	if not get_viewport_rect().has_point(global_position):
		queue_free()

func _on_Bullet_body_entered(body):
	if body.name == "Player" and body.has_method("take_damage"):
		body.take_damage(1)
		queue_free()

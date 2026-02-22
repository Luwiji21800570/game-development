extends CharacterBody2D

const SPEED = 300.0
const DASH_SPEED = 500.0
const DETECT_RANGE = 200.0
const EXPLOSION_RANGE = 200.0

var hp := 20
var is_dashing := false

@onready var animated_sprite = $AnimatedSprite2D

func _ready() -> void:
	animated_sprite.play("idle")

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	var player = _get_player_in_sight()

	if is_dashing and player:
		var direction = sign(player.global_position.x - global_position.x)
		velocity.x = direction * DASH_SPEED
		animated_sprite.scale.x = abs(animated_sprite.scale.x) * direction
	elif not is_dashing:
		var direction := Input.get_axis("ui_left", "ui_right")
		if direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

func _get_player_in_sight() -> Node2D:
	var space_state = get_world_2d().direct_space_state
	var players = get_tree().get_nodes_in_group("player")
	if players.is_empty():
		return null

	var player = players[0]
	var distance = global_position.distance_to(player.global_position)

	if distance > DETECT_RANGE:
		return null

	if abs(player.global_position.y - global_position.y) > 60:
		return null

	var query = PhysicsRayQueryParameters2D.create(global_position, player.global_position)
	query.exclude = [self]
	var result = space_state.intersect_ray(query)

	if result and result.collider.is_in_group("player"):
		return player

	return null

func take_damage(amount: int) -> void:
	hp -= amount
	if hp <= 0:
		_pop()

func _pop() -> void:
	set_physics_process(false)
	set_collision_layer(0)
	set_collision_mask(0)
	animated_sprite.play("explode")
	await animated_sprite.animation_finished
	_explosion_damage()
	queue_free()

func _explosion_damage() -> void:
	var players = get_tree().get_nodes_in_group("player")
	print("Checking explosion damage, players found: ", players.size())
	for player in players:
		var distance = global_position.distance_to(player.global_position)
		print("Player distance: ", distance, " | Explosion range: ", EXPLOSION_RANGE)
		if distance <= EXPLOSION_RANGE:
			player.take_damage(3)
			print("Explosion hit player!")

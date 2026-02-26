extends CharacterBody2D

const SPEED = 300.0
const EXPLOSION_RANGE = 200.0

var hp := 20

@onready var animated_sprite = $AnimatedSprite2D
@onready var hp_bar = $HPBar

func _ready() -> void:
	animated_sprite.play("idle")
	hp_bar.max_value = hp
	hp_bar.value = hp

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	velocity.x = move_toward(velocity.x, 0, SPEED)
	move_and_slide()

func take_damage(amount: int) -> void:
	hp -= amount
	hp_bar.value = hp
	var dmg = preload("res://damage_number.tscn").instantiate()
	dmg.position = global_position + Vector2(0, -40)
	get_parent().add_child(dmg)
	dmg.show_damage(amount)
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
	for player in players:
		var distance = global_position.distance_to(player.global_position)
		if distance <= EXPLOSION_RANGE:
			player.take_damage(3)

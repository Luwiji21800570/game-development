extends CharacterBody2D

@export var gravity := 900.0
@export var detection_range := 200.0
@export var hp := 30
@export var damage_cooldown := 1.0

var is_attacking := false
var player = null
var damage_timer := 0.0
var player_in_area := false

@onready var sprite := $AnimatedSprite2D
@onready var damage_area = $Area2D

func _ready():
	sprite.animation_finished.connect(_on_animation_finished)
	sprite.play("idle")
	damage_area.body_entered.connect(_on_body_entered)
	damage_area.body_exited.connect(_on_body_exited)
	await get_tree().process_frame
	player = get_tree().get_first_node_in_group("player")

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	move_and_slide()

	# Handle damage ticking
	if player_in_area and player != null:
		damage_timer -= delta
		if damage_timer <= 0:
			player.take_damage(1)
			damage_timer = damage_cooldown

	if player == null:
		return
	var distance = global_position.distance_to(player.global_position)
	if distance <= detection_range and not is_attacking:
		var dir = sign(player.global_position.x - global_position.x)
		sprite.scale.x = abs(sprite.scale.x) * dir
		_do_attack()

func _do_attack():
	is_attacking = true
	sprite.play("attack")

func _on_animation_finished():
	if sprite.animation == "attack":
		is_attacking = false
		sprite.play("idle")

func _on_body_entered(body):
	if body.is_in_group("player"):
		player_in_area = true
		damage_timer = 0  # deal damage immediately on enter
		player.take_damage(1)
		damage_timer = damage_cooldown

func _on_body_exited(body):
	if body.is_in_group("player"):
		player_in_area = false

func take_damage(amount):
	hp -= amount
	if hp <= 0:
		queue_free()

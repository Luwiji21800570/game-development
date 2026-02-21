extends CharacterBody2D

@export var gravity := 900.0
@export var detection_range := 200.0
@export var hp := 30

var is_attacking := false
var player = null

@onready var sprite := $AnimatedSprite2D

func _ready():
	sprite.animation_finished.connect(_on_animation_finished)
	sprite.play("idle")
	await get_tree().process_frame
	player = get_tree().get_first_node_in_group("player")
	print("Player found: ", player)

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	move_and_slide()

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

func take_damage(amount):
	hp -= amount
	print("Enemy HP: ", hp)
	if hp <= 0:
		queue_free()

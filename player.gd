extends CharacterBody2D

@export var speed := 200.0
@export var jump_force := -400.0
@export var gravity := 900.0
@export var dodge_speed := 600.0
@export var dodge_time := 0.2
@export var dodge_cooldown := 1.0
@export var attack_damage := 10

var is_dodging := false
var can_dodge := true
var dodge_timer := 0.0
var is_attacking := false
var is_special := false
var jump_count := 0
var max_jumps := 1
var pause_menu : Control
var hud : CanvasLayer

@onready var sprite := $AnimatedSprite2D
@onready var hitbox := $Hitbox
@onready var special_hitbox := $SpecialHitbox

func _ready():
	sprite.animation_finished.connect(_on_animation_finished)
	hitbox.monitoring = false
	hitbox.body_entered.connect(_on_hitbox_body_entered)
	special_hitbox.monitoring = false
	special_hitbox.collision_mask = 2
	special_hitbox.body_entered.connect(_on_special_hitbox_body_entered)
	if Global.current_level == 2:
		max_jumps = 2
	pause_menu = preload("res://pause_menu.tscn").instantiate()
	get_tree().root.add_child(pause_menu)
	hud = preload("res://hud.tscn").instantiate()
	get_tree().root.add_child(hud)

func _physics_process(delta):
	if Input.is_action_just_pressed("pause"):
		pause_menu.visible = !pause_menu.visible
		get_tree().paused = pause_menu.visible

	var direction := 0

	if not is_dodging and not is_attacking and not is_special:
		if Input.is_action_pressed("move_right"):
			direction += 1
		if Input.is_action_pressed("move_left"):
			direction -= 1
		velocity.x = direction * speed

	if direction != 0:
		sprite.scale.x = abs(sprite.scale.x) * sign(direction)

	if not is_on_floor():
		velocity.y += gravity * delta

	if is_on_floor():
		jump_count = 0

	if Input.is_action_just_pressed("jump") and jump_count < max_jumps and not is_dodging:
		velocity.y = jump_force
		jump_count += 1

	if Input.is_action_just_pressed("attack") and not is_attacking and not is_special and not is_dodging:
		is_attacking = true
		hitbox.monitoring = true
		sprite.play("attack")

	if Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT) and not is_attacking and not is_special and not is_dodging:
		is_special = true
		special_hitbox.monitoring = true
		sprite.play("special")  # replace with your special animation name

	if Input.is_action_just_pressed("dodge") and can_dodge and not is_dodging and not is_attacking and not is_special:
		is_dodging = true
		can_dodge = false
		dodge_timer = dodge_time
		if direction == 0:
			direction = sign(sprite.scale.x)
		velocity.x = direction * dodge_speed
		velocity.y = 0

	if is_dodging:
		dodge_timer -= delta
		if dodge_timer <= 0:
			is_dodging = false
			velocity.x = 0

	if not can_dodge and is_on_floor() and not is_dodging:
		can_dodge = true

	move_and_slide()

func _on_animation_finished():
	if sprite.animation == "attack":
		is_attacking = false
		hitbox.monitoring = false
		sprite.play("idle")
	elif sprite.animation == "special":
		is_special = false
		special_hitbox.monitoring = false
		sprite.play("idle")
	elif sprite.animation == "death":
		_show_death_menu()

func _on_hitbox_body_entered(body):
	if body.has_method("take_damage"):
		body.take_damage(attack_damage)

func _on_special_hitbox_body_entered(body):
	if body.has_method("take_damage"):
		var multiplier = randf_range(1.5, 3.0)
		var damage = int(attack_damage * multiplier)
		print("Special hit! Damage: ", damage)
		body.take_damage(damage)

func take_damage(amount: int):
	hud.take_damage(amount)

func die():
	set_physics_process(false)
	set_collision_layer(0)
	set_collision_mask(0)
	sprite.play("death")

func _show_death_menu():
	var death_menu = preload("res://death_menu.tscn").instantiate()
	get_tree().root.add_child(death_menu)

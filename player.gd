extends CharacterBody2D

# === Player Movement Settings ===
@export var speed := 200.0
@export var jump_force := -400.0
@export var gravity := 900.0
# === Dodge Settings ===
@export var dodge_speed := 600.0
@export var dodge_time := 0.2
@export var dodge_cooldown := 1.0
# === Attack Settings ===
@export var attack_damage := 10
# === Internal variables ===
var is_dodging := false
var can_dodge := true
var dodge_timer := 0.0
var is_attacking := false
var jump_count := 0
var max_jumps := 1
var pause_menu : Control

@onready var sprite := $AnimatedSprite2D
@onready var hitbox := $Hitbox

func _ready():
	sprite.animation_finished.connect(_on_animation_finished)
	hitbox.monitoring = false
	hitbox.body_entered.connect(_on_hitbox_body_entered)
	if Global.current_level == 2:
		max_jumps = 2
	pause_menu = preload("res://pause_menu.tscn").instantiate()
	get_tree().root.add_child(pause_menu)

func _physics_process(delta):
	# ----------------------------
	# 0️⃣ Pause Menu
	# ----------------------------
	if Input.is_action_just_pressed("pause"):
		pause_menu.visible = !pause_menu.visible
		get_tree().paused = pause_menu.visible
	var direction := 0
	# ----------------------------
	# 1️⃣ Handle Horizontal Input
	# ----------------------------
	if not is_dodging and not is_attacking:
		if Input.is_action_pressed("move_right"):
			direction += 1
		if Input.is_action_pressed("move_left"):
			direction -= 1
		velocity.x = direction * speed
	# ----------------------------
	# 1️⃣a Update Facing Direction
	# ----------------------------
	if direction != 0:
		sprite.scale.x = abs(sprite.scale.x) * sign(direction)
	# ----------------------------
	# 2️⃣ Apply Gravity
	# ----------------------------
	if not is_on_floor():
		velocity.y += gravity * delta
	# ----------------------------
	# 3️⃣ Jump (with double jump in level 2)
	# ----------------------------
	if is_on_floor():
		jump_count = 0
	if Input.is_action_just_pressed("jump") and jump_count < max_jumps and not is_dodging:
		velocity.y = jump_force
		jump_count += 1
	# ----------------------------
	# 4️⃣ Attack
	# ----------------------------
	if Input.is_action_just_pressed("attack") and not is_attacking and not is_dodging:
		is_attacking = true
		hitbox.monitoring = true
		sprite.play("attack")
	# ----------------------------
	# 5️⃣ Dodge Mechanic
	# ----------------------------
	if Input.is_action_just_pressed("dodge") and can_dodge and not is_dodging and not is_attacking:
		is_dodging = true
		can_dodge = false
		dodge_timer = dodge_time
		if direction == 0:
			direction = sign(sprite.scale.x)
		velocity.x = direction * dodge_speed
		velocity.y = 0
	# ----------------------------
	# 6️⃣ Handle Dodge Timer
	# ----------------------------
	if is_dodging:
		dodge_timer -= delta
		if dodge_timer <= 0:
			is_dodging = false
			velocity.x = 0
	# ----------------------------
	# 7️⃣ Reset dodge cooldown
	# ----------------------------
	if not can_dodge and is_on_floor() and not is_dodging:
		can_dodge = true
	# ----------------------------
	# 8️⃣ Apply Movement
	# ----------------------------
	move_and_slide()

func _on_animation_finished():
	if sprite.animation == "attack":
		is_attacking = false
		hitbox.monitoring = false
		sprite.play("idle")

func _on_hitbox_body_entered(body):
	if body.has_method("take_damage"):
		body.take_damage(attack_damage)

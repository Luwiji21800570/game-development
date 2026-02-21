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

@onready var sprite := $AnimatedSprite2D
@onready var hitbox := $Hitbox  # Area2D child node

func _ready():
	sprite.animation_finished.connect(_on_animation_finished)
	hitbox.monitoring = false  # hitbox only active during attack

func _physics_process(delta):
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
	# 3️⃣ Jump
	# ----------------------------
	if Input.is_action_just_pressed("jump") and is_on_floor() and not is_dodging:
		velocity.y = jump_force

	# ----------------------------
	# 4️⃣ Attack
	# ----------------------------
	if Input.is_action_just_pressed("attack") and not is_attacking and not is_dodging:
		is_attacking = true
		hitbox.monitoring = true  # enable hitbox during attack
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
		hitbox.monitoring = false  # disable hitbox after attack
		sprite.play("idle")

func _on_hitbox_body_entered(body):
	print("Hitbox hit: ", body.name)
	print("Has take_damage: ", body.has_method("take_damage"))
	if body.has_method("take_damage"):
		body.take_damage(attack_damage)
		
	

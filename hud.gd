extends CanvasLayer

var hearts = []
var max_hp := 12
var current_hp := 12
var is_dead := false

func _ready():
	current_hp = Global.current_hp
	for i in 3:
		var heart = AnimatedSprite2D.new()
		heart.sprite_frames = $Heart1.sprite_frames
		heart.animation = "default"
		heart.frame = 0
		heart.position = Vector2(980 + i * 40, 20)
		add_child(heart)
		hearts.append(heart)
	update_hearts()

func update_hearts():
	for i in 3:
		var heart_hp = clamp(current_hp - i * 4, 0, 4)
		var frame = 4 - heart_hp
		hearts[i].frame = frame

func take_damage(amount: int):
	if is_dead:
		return
	current_hp -= amount
	current_hp = max(current_hp, 0)
	Global.current_hp = current_hp
	update_hearts()
	if current_hp <= 0:
		is_dead = true
		# Find player and trigger death
		var player = get_tree().get_first_node_in_group("player")
		if player:
			player.die()

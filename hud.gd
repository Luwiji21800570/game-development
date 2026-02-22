extends CanvasLayer

var hearts = []
var max_hp := 12
var current_hp := 12
var special_label : Label

@onready var special_icon := $SpecialIcon

func _ready():
	current_hp = Global.current_hp

	# Hearts
	for i in 3:
		var heart = AnimatedSprite2D.new()
		heart.sprite_frames = $Heart1.sprite_frames
		heart.animation = "default"
		heart.frame = 0
		heart.position = Vector2(980 + i * 40, 20)
		add_child(heart)
		hearts.append(heart)
	update_hearts()

	# Container box at middle bottom
	var container = Control.new()
	container.position = Vector2(536, 560)
	add_child(container)

	# Box background
	var box = ColorRect.new()
	box.color = Color(0, 0, 0, 0.6)
	box.size = Vector2(80, 90)
	box.position = Vector2(0, 0)
	container.add_child(box)

	# Move special icon into container
	special_icon.reparent(container)
	special_icon.stop()
	special_icon.position = Vector2(40, 30)  # centered inside box

	# Cooldown label inside container
	special_label = Label.new()
	special_label.position = Vector2(10, 62)
	special_label.size = Vector2(80, 20)
	special_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	special_label.add_theme_color_override("font_color", Color.WHITE)
	special_label.add_theme_font_size_override("font_size", 14)
	special_label.text = "READY"
	container.add_child(special_label)

func update_hearts():
	for i in 3:
		var heart_hp = clamp(current_hp - i * 4, 0, 4)
		var frame = 4 - heart_hp
		hearts[i].frame = frame

func take_damage(amount: int):
	if current_hp <= 0:
		return
	current_hp -= amount
	current_hp = max(current_hp, 0)
	Global.current_hp = current_hp
	update_hearts()
	if current_hp <= 0:
		var player = get_tree().get_first_node_in_group("player")
		if player:
			player.die()

func update_special_cooldown(remaining: float):
	if remaining <= 0:
		special_label.text = "READY"
		special_icon.modulate = Color(1, 1, 1, 1)
	else:
		special_label.text = str(ceil(remaining)) + "s"
		special_icon.modulate = Color(0.4, 0.4, 0.4, 1)

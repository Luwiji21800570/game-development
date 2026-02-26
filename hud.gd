extends CanvasLayer

var hearts = []
var max_hp := 12
var current_hp := 12
var special_label : Label
var level_label : Label

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
	special_icon.position = Vector2(40, 30)

	# Cooldown label inside container
	special_label = Label.new()
	special_label.position = Vector2(10, 62)
	special_label.size = Vector2(80, 20)
	special_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	special_label.add_theme_color_override("font_color", Color.WHITE)
	special_label.add_theme_font_size_override("font_size", 14)
	special_label.text = "READY"
	container.add_child(special_label)

	# Level notification
	level_label = Label.new()
	level_label.add_theme_font_size_override("font_size", 48)
	level_label.add_theme_color_override("font_color", Color.WHITE)
	level_label.add_theme_constant_override("outline_size", 3)
	level_label.add_theme_color_override("font_outline_color", Color.BLACK)
	level_label.position = Vector2(576 - 75, 50)
	level_label.text = "Level " + str(Global.current_level)
	level_label.modulate.a = 0.0
	add_child(level_label)
		# Subtitle for level 2
	if Global.current_level == 2:
		var subtitle = Label.new()
		subtitle.add_theme_font_size_override("font_size", 18)
		subtitle.add_theme_color_override("font_color", Color.YELLOW)
		subtitle.add_theme_constant_override("outline_size", 2)
		subtitle.add_theme_color_override("font_outline_color", Color.BLACK)
		subtitle.position = Vector2(576 - 220, 110)
		subtitle.text = "You have temporarily unlocked double jump for this level!"
		subtitle.modulate.a = 0.0
		add_child(subtitle)
		var tween2 = create_tween()
		tween2.tween_property(subtitle, "modulate:a", 1.0, 0.5)
		tween2.tween_interval(2.0)
		tween2.tween_property(subtitle, "modulate:a", 0.0, 0.5)
	_flash_level_label()

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

func _flash_level_label():
	var tween = create_tween()
	tween.tween_property(level_label, "modulate:a", 1.0, 0.5)
	tween.tween_interval(1.5)
	tween.tween_property(level_label, "modulate:a", 0.0, 0.5)

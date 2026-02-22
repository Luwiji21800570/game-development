extends Control

var level1_button : Button
var level2_button : Button
var bg : TextureRect
var bg_offset := 0.0
var scroll_speed := 30.0

func _ready():
	# Background image
	bg = TextureRect.new()
	bg.texture = load("res://terrar.png")  # change this
	bg.stretch_mode = TextureRect.STRETCH_TILE
	bg.size = Vector2(1152 * 2, 648)
	add_child(bg)

	# Title
	var title = Label.new()
	title.text = "SELECT LEVEL"
	title.add_theme_font_size_override("font_size", 48)
	title.position = Vector2(576 - 160, 150)
	# Black font color
	title.add_theme_color_override("font_color", Color.BLACK)
	# Outline
	title.add_theme_constant_override("outline_size", 2)
	title.add_theme_color_override("font_outline_color", Color.WHITE)
	add_child(title)

	# Level 1 button
	level1_button = Button.new()
	level1_button.text = "Level 1"
	level1_button.size = Vector2(200, 60)
	level1_button.position = Vector2(476, 300)
	level1_button.pressed.connect(_on_level1_pressed)
	_style_button(level1_button)
	add_child(level1_button)

	# Level 2 button
	level2_button = Button.new()
	level2_button.size = Vector2(200, 60)
	level2_button.position = Vector2(476, 400)
	level2_button.pressed.connect(_on_level2_pressed)
	_style_button(level2_button)
	add_child(level2_button)

	if Global.levels_unlocked < 2:
		level2_button.disabled = true
		level2_button.text = "Level 2 🔒"
	else:
		level2_button.disabled = false
		level2_button.text = "Level 2"

func _style_button(button: Button) -> void:
	# Normal style
	var style = StyleBoxFlat.new()
	style.bg_color = Color(1, 1, 1, 0.7)  # semi-transparent white
	style.border_width_left = 3
	style.border_width_right = 3
	style.border_width_top = 3
	style.border_width_bottom = 3
	style.border_color = Color.BLACK
	style.corner_radius_top_left = 8
	style.corner_radius_top_right = 8
	style.corner_radius_bottom_left = 8
	style.corner_radius_bottom_right = 8
	button.add_theme_stylebox_override("normal", style)

	# Hover style
	var hover_style = StyleBoxFlat.new()
	hover_style.bg_color = Color(0.9, 0.9, 0.9, 0.9)
	hover_style.border_width_left = 3
	hover_style.border_width_right = 3
	hover_style.border_width_top = 3
	hover_style.border_width_bottom = 3
	hover_style.border_color = Color.BLACK
	hover_style.corner_radius_top_left = 8
	hover_style.corner_radius_top_right = 8
	hover_style.corner_radius_bottom_left = 8
	hover_style.corner_radius_bottom_right = 8
	button.add_theme_stylebox_override("hover", hover_style)

	# Font color
	button.add_theme_color_override("font_color", Color.BLACK)
	button.add_theme_color_override("font_hover_color", Color.BLACK)
	button.add_theme_font_size_override("font_size", 20)

func _process(delta):
	bg_offset += scroll_speed * delta
	if bg_offset >= 1152:
		bg_offset = 0
	bg.position.x = -bg_offset

func _on_level1_pressed():
	Global.current_level = 1
	get_tree().change_scene_to_file("res://Main.tscn")

func _on_level2_pressed():
	Global.current_level = 2
	get_tree().change_scene_to_file("res://level2.tscn")

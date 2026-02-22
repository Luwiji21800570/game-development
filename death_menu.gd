extends CanvasLayer

func _ready():
	get_tree().paused = true
	process_mode = Node.PROCESS_MODE_ALWAYS

	# Dark overlay
	var overlay = ColorRect.new()
	overlay.color = Color(0, 0, 0, 0.6)
	overlay.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(overlay)

	# "You Died" label
	var label = Label.new()
	label.text = "YOU DIED"
	label.add_theme_font_size_override("font_size", 64)
	label.add_theme_color_override("font_color", Color.RED)
	label.position = Vector2(576 - 140, 200)
	add_child(label)

	# Respawn button
	var respawn_btn = Button.new()
	respawn_btn.text = "Respawn"
	respawn_btn.size = Vector2(200, 60)
	respawn_btn.position = Vector2(476, 340)
	respawn_btn.pressed.connect(_on_respawn)
	add_child(respawn_btn)

	# Main menu button
	var menu_btn = Button.new()
	menu_btn.text = "Main Menu"
	menu_btn.size = Vector2(200, 60)
	menu_btn.position = Vector2(476, 420)
	menu_btn.pressed.connect(_on_main_menu)
	add_child(menu_btn)

func _on_respawn():
	get_tree().paused = false
	Global.current_hp = 12
	queue_free()
	get_tree().reload_current_scene()

func _on_main_menu():
	get_tree().paused = false
	Global.current_hp = 12
	queue_free()
	get_tree().change_scene_to_file("res://menu.tscn")

extends Control

func _ready():
	visible = false
	process_mode = Node.PROCESS_MODE_ALWAYS  # runs even when paused

	# Dark overlay
	var overlay = ColorRect.new()
	overlay.color = Color(0, 0, 0, 0.5)
	overlay.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(overlay)

	# Resume button
	var resume_btn = Button.new()
	resume_btn.text = "Resume"
	resume_btn.size = Vector2(200, 60)
	resume_btn.position = Vector2(476, 250)
	resume_btn.pressed.connect(_on_resume)
	add_child(resume_btn)

	# Main menu button
	var menu_btn = Button.new()
	menu_btn.text = "Main Menu"
	menu_btn.size = Vector2(200, 60)
	menu_btn.position = Vector2(476, 340)
	menu_btn.pressed.connect(_on_main_menu)
	add_child(menu_btn)

func _on_resume():
	visible = false
	get_tree().paused = false

func _on_main_menu():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://menu.tscn")

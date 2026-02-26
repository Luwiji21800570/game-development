extends Node2D

func show_damage(amount: int, is_special: bool = false):
	var label = Label.new()
	label.text = str(amount)
	label.add_theme_font_size_override("font_size", 20 if not is_special else 28)
	label.add_theme_color_override("font_color", Color.YELLOW if not is_special else Color.ORANGE)
	label.add_theme_constant_override("outline_size", 2)
	label.add_theme_color_override("font_outline_color", Color.BLACK)
	label.position = Vector2(-10, -20)
	add_child(label)

	var tween = create_tween()
	tween.tween_property(label, "position:y", -60, 0.8)
	tween.parallel().tween_property(label, "modulate:a", 0.0, 0.8)
	tween.tween_callback(queue_free)

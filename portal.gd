extends Area2D
@export var next_level_path : String

@onready var animated_sprite = $AnimatedSprite2D

func _ready():
	body_entered.connect(_on_body_entered)
	animated_sprite.play("idle")  # replace with your animation name

func _on_body_entered(body):
	if body.name == "Player" and visible:
		Global.current_level = 2
		get_tree().change_scene_to_file(next_level_path)

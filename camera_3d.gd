extends Camera3D

@onready var player = $"../Player"
var offset := Vector3(0, 5, 10)
var mouse_sensitivity := 0.003
var yaw := 0.0
var pitch := -0.3

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	if event is InputEventMouseMotion:
		yaw -= event.relative.x * mouse_sensitivity
		pitch -= event.relative.y * mouse_sensitivity
		pitch = clamp(pitch, -1.2, 0.2)
	if event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _physics_process(delta):
	var rot = Basis.from_euler(Vector3(pitch, yaw, 0))
	global_position = player.global_position + rot * offset
	look_at(player.global_position, Vector3.UP)

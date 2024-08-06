class_name Z_CameraShake extends Node

## How quickly the shaking stops [0, 1].
@export var decay : float = 0.8
## Maximum hor/ver shake in pixels.
@export var max_offset := Vector2(100, 75)
## Maximum rotation in radians (use sparingly).
@export var max_roll : float = 0.1
## Assign the node this camera will follow.
@export var target : NodePath
## Current shake strength.
@export var trauma : float = 0.0
## Current constant shake strength, setting this will make the camera shake until its set back to 0.
@export var constant_trauma : float = 0.0
## Trauma exponent. Use [2, 3].
@export var trauma_power : float = 2

@export var auto_physics_process : bool = false

var camera : Camera2D

func on_sig_camera_trauma_request(t:float, m:float=0.3):
	trauma = m if (trauma + t >= m) else trauma + t

func on_sig_camera_trauma_relief(t:float):
	trauma = clamp(trauma - t, 0, 1.0)

func on_sig_camera_trauma_clear():
	trauma = 0

func on_sig_camera_constant_trauma_request(t:float, m:float=0.3):
	constant_trauma = m if (constant_trauma + t >= m) else constant_trauma + t

func on_sig_camera_constant_trauma_relief(t:float):
	constant_trauma = clamp(constant_trauma - t, 0, 1.0)

func on_sig_camera_constant_trauma_clear():
	constant_trauma = 0.0

func on_sig_global_camera_set(new_cam:Camera2D, _old_cam:Camera2D=null):
	if camera == new_cam: return
	camera = new_cam

func connect_signals():
	__z.bus.sig_global_camera_set.connect(on_sig_global_camera_set)
	Z_SignalsUtil.signal_connect_prefix(self, Z_CameraShakeSignals.single())
	if camera: on_sig_global_camera_set(camera)

func with_auto_physics_process(val:=false) -> Z_CameraShake:
	auto_physics_process = val
	return self

func _ready() -> void:
	set_physics_process(auto_physics_process)
	if not camera:
		var parent := get_parent() as Camera2D
		camera = parent if parent else Z_Global.camera
	connect_signals()

func _physics_process(delta: float) -> void: do_process(delta)

func do_process(delta:float):
	if constant_trauma and not is_zero_approx(constant_trauma) and constant_trauma > 0:
		shake_pure_random(constant_trauma)
	elif trauma:
		trauma = max(trauma - decay * delta, 0)
		shake_pure_random(trauma)

func shake_pure_random(t:=trauma):
	var amount = pow(t, trauma_power)
	camera.rotation = max_roll * amount * randf_range(-1, 1)
	camera.offset.x = max_offset.x * amount * randf_range(-1, 1)
	camera.offset.y = max_offset.y * amount * randf_range(-1, 1)

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

@export var noise_y : float = 0.0

@onready var camera : Camera2D = __zaft.global.camera
@onready var noise : FastNoiseLite = FastNoiseLite.new()

func on_trauma_requested(t:float, m:float=1.0):
  if trauma + t >= m: trauma = m
  trauma += t

func on_trauma_relieved(t:float):
  trauma = clamp(trauma - t, 0, 1000.0)

func on_trauma_cleared():
  trauma = 0

func on_constant_trauma_requested(t:float):
  constant_trauma += t

func on_constant_trauma_relieved(t:float):
  constant_trauma = clamp(constant_trauma - t, 0, 1000.0)

func on_constant_trauma_cleared():
  constant_trauma = 0.0

func connect_signals():
  __zaft.bus.sig_camera_constant_trauma_request.connect(on_constant_trauma_requested)
  __zaft.bus.sig_camera_constant_trauma_relief.connect(on_constant_trauma_relieved)
  __zaft.bus.sig_camera_constant_trauma_clear.connect(on_constant_trauma_cleared)
  __zaft.bus.sig_camera_trauma_request.connect(on_trauma_requested)
  __zaft.bus.sig_camera_trauma_relief.connect(on_trauma_relieved)
  __zaft.bus.sig_camera_trauma_clear.connect(on_trauma_cleared)

func _ready() -> void:
  init_noise()
  connect_signals()

func init_noise():
  noise.seed = randi()
  noise.frequency = 0.25
  noise.fractal_octaves = 2
  noise_y = 0.0

func do_process(delta:float):
  if constant_trauma and not is_zero_approx(constant_trauma) and constant_trauma > 0:
    shake_pure_random(constant_trauma)
  elif trauma:
    trauma = max(trauma - decay * delta, 0)
    # shake_noisy_random()
    shake_pure_random(trauma)

func shake_noisy_random(t:=trauma):
  var amount = pow(t, trauma_power)
  noise_y += 1
  camera.rotation = max_roll * amount * noise.get_noise_2d(noise.seed, noise_y)
  camera.offset.x = max_offset.x * amount * noise.get_noise_2d(noise.seed*2, noise_y)
  camera.offset.y = max_offset.y * amount * noise.get_noise_2d(noise.seed*3, noise_y)

func shake_pure_random(t:=trauma):
  var amount = pow(t, trauma_power)
  camera.rotation = max_roll * amount * randf_range(-1, 1)
  camera.offset.x = max_offset.x * amount * randf_range(-1, 1)
  camera.offset.y = max_offset.y * amount * randf_range(-1, 1)

func add_trauma(amount):
  trauma = min(trauma + amount, 1.0)

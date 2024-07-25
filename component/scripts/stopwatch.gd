class_name Z_Stopwatch extends Z_ComponentBase

@export var autostart := false
@export var running := false : set = set_running

var elapsed : float = 0.0

func _enter_tree() -> void:
  add_to_group(Z_Autoload_Path.STOPWATCH_GROUP)

func _ready() -> void:
  super()
  if autostart:
    running = true
  if running:
    set_process(process_using == PROCESS_USING.Normal)
    set_physics_process(process_using == PROCESS_USING.Physics)
  else:
    set_process(false)
    set_physics_process(false)

func reset():
  elapsed = 0.0

func stop():
  running = false
  reset()

func pause():
  running = false

func resume():
  running = true

func start():
  elapsed = 0.0
  running = true

func component_process(delta:float):
  elapsed += delta

func set_running(v:bool=false):
  if running == v: return
  running = v
  if running:
    set_process(process_using == PROCESS_USING.Normal)
    set_physics_process(process_using == PROCESS_USING.Physics)
  else:
    set_process(false)
    set_physics_process(false)

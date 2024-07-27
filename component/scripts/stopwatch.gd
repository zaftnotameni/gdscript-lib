class_name Z_Stopwatch extends Node

@export var process_using := Z_ComponentBase.PROCESS_USING.None
@export var autostart := false
@export var running := false
@export var autostart_when_in_game_mode := false

var elapsed : float = 0.0

func autostarts_in_game_mode(does_it_autostart_in_game_mode:=false) -> Z_Stopwatch:
  autostart_when_in_game_mode = does_it_autostart_in_game_mode
  return self

func process_using_idleframe() -> Z_Stopwatch:
  process_using = Z_ComponentBase.PROCESS_USING.Normal
  return self

func on_game_state_changed(next:Z_Autoload_State.GAME_STATE,_prev:Z_Autoload_State.GAME_STATE):
  if autostart_when_in_game_mode and next == Z_Autoload_State.GAME_STATE.Game:
    set_running(true)
  elif next == Z_Autoload_State.GAME_STATE.Title:
    set_running(false)
    elapsed = 0.0
  else:
    set_running(false)

func _enter_tree() -> void:
  name = 'Stopwatch'
  add_to_group(Z_Autoload_Path.STOPWATCH_GROUP)

func _ready() -> void:
  process_mode = ProcessMode.PROCESS_MODE_ALWAYS
  set_running(autostart)
  if running:
    set_process(process_using == Z_ComponentBase.PROCESS_USING.Normal)
    set_physics_process(process_using == Z_ComponentBase.PROCESS_USING.Physics)
  else:
    set_process(false)
    set_physics_process(false)
  __zaft.bus.sig_game_state_changed.connect(on_game_state_changed)

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

func _process(delta: float) -> void:
  elapsed += delta

func _physics_process(delta: float) -> void:
  elapsed += delta

func set_running(v:bool=false):
  if running == v: return
  running = v
  if running:
    set_process(process_using == Z_ComponentBase.PROCESS_USING.Normal)
    set_physics_process(process_using == Z_ComponentBase.PROCESS_USING.Physics)
  else:
    set_process(false)
    set_physics_process(false)

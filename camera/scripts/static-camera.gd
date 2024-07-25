class_name Z_StaticCamera extends Camera2D

@export var target_node : Node2D
@export var uses_physics_process : bool

@onready var shake := Z_CameraShake.new()

func do_process(delta:float):
  shake.do_process(delta)

func _ready() -> void:
  set_process(not uses_physics_process and (process_callback == CAMERA2D_PROCESS_IDLE))
  set_physics_process(uses_physics_process or (process_callback == CAMERA2D_PROCESS_PHYSICS))
  add_child(shake)

func _physics_process(delta: float) -> void: do_process(delta)
func _process(delta: float) -> void: do_process(delta)

func on_player_global_changed(p:Node2D,_prev=null):
  if target_node == p: return
  target_node = p

func _enter_tree() -> void:
  anchor_mode = ANCHOR_MODE_FIXED_TOP_LEFT
  add_to_group(__zaft.path.MAIN_CAMERA_GROUP)
  __zaft.global.register_camera(self)

func _exit_tree() -> void:
  if __zaft.global.camera == self:
    __zaft.global.register_camera(null)

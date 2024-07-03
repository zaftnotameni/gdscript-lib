class_name Zaft_FollowCamera extends Camera2D

@export var target_node : Node2D
@export var follow_slerpiness : float = 5.0
@export var home_slerpiness : float = 10.0
@export var follows_player : bool
@export var home_position: Vector2

static func follow_target(c:Camera2D,p:Vector2,s:float,delta:float):
  if not c: return
  if not p: return
  c.global_position = c.global_position.slerp(p, min(1.0, absf(s) * delta))

func do_process(delta:float):
  if target_node:
    follow_target(self, target_node.global_position, follow_slerpiness, delta)
  else:
    follow_target(self, home_position, home_slerpiness, delta)

func _ready() -> void:
  if not home_position: home_position = global_position
  set_process(process_callback == CAMERA2D_PROCESS_IDLE)
  set_physics_process(process_callback == CAMERA2D_PROCESS_PHYSICS)
  if follows_player:
    if not target_node: target_node = __zaft.global.player
    __zaft.global.sig_player_set.connect(on_player_global_changed)

func _physics_process(delta: float) -> void:
  do_process(delta)

func _process(delta: float) -> void:
  do_process(delta)

func on_player_global_changed(p:CharacterBody2D,_prev=null):
  if target_node == p: return
  target_node = p

func _enter_tree() -> void:
  add_to_group(__zaft.path.MAIN_CAMERA_GROUP)
  __zaft.global.register_camera(self)

func _exit_tree() -> void:
  if __zaft.global.camera == self:
    __zaft.global.register_camera(null)

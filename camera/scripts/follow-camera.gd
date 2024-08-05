class_name Z_FollowCamera extends Camera2D

@export var target_node : Node2D
@export var follow_slerpiness : float = 5.0
@export var home_slerpiness : float = 10.0
@export var follows_player : bool
@export var uses_physics_process : bool
@export var home_position: Vector2
@export var parallax_strength: float = 0.001

@onready var shake := Z_CameraShake.new()

func follow_target(c:Camera2D,p:Vector2,s:float,delta:float):
  if not c: return
  if not p: return
  c.global_position = c.global_position.slerp(p, min(1.0, absf(s) * delta))
  update_parallax(c)

func update_parallax(c:Camera2D):
  var nodes := get_tree().get_nodes_in_group(__z.path.MAIN_CAMERA_PARALLAX_GROUP)
  for n in nodes:
    if 'material' in n:
      if n.material is ShaderMaterial:
        if n.material.shader is Shader:
          n.material.set_shader_parameter('parallax_offset', c.global_position)
          n.material.set_shader_parameter('parallax_strength', parallax_strength)

func do_process(delta:float):
  shake.do_process(delta)
  if Z_Util.node_is_there(target_node):
    follow_target(self, target_node.global_position, follow_slerpiness, delta)
  else:
    target_node = null
    follow_target(self, home_position, home_slerpiness, delta)

func _ready() -> void:
  if not home_position: home_position = global_position
  set_process(not uses_physics_process and (process_callback == CAMERA2D_PROCESS_IDLE))
  set_physics_process(uses_physics_process or (process_callback == CAMERA2D_PROCESS_PHYSICS))
  add_child(shake)
  if follows_player:
    if not target_node: target_node = __z.global.player
    __z.global.sig_player_set.connect(on_player_global_changed)

func _physics_process(delta: float) -> void: do_process(delta)
func _process(delta: float) -> void: do_process(delta)

func on_player_global_changed(p:Node2D,_prev=null):
  if target_node == p: return
  target_node = p

func _enter_tree() -> void:
  print_verbose('follow camera enter tree')
  add_to_group(__z.path.MAIN_CAMERA_GROUP)
  __z.global.register_camera(self)

func _exit_tree() -> void:
  print_verbose('follow camera exit tree')
  if __z.global.camera == self:
    __z.global.register_camera(null)

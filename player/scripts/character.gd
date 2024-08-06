class_name Z_PlayerCharacter extends CharacterBody2D

@export var stats : Z_PlayerStats
@export var machine : Z_PlayerStateMachine

@onready var viz : Node2D = $V

var camera : Z_FollowCamera

static func becomes_ready() -> Z_PlayerCharacter:
  return await Z_Path.await_for_first_node_in_group(Z_Path.PLAYER_CHARACTER_GROUP)

func _enter_tree() -> void:
  add_to_group(Z_Path.PLAYER_CHARACTER_GROUP)
  Z_Global.register_player(self)

func _exit_tree() -> void:
  if Z_Global.player == self:
    Z_Global.register_player(null)

func _physics_process(_delta: float) -> void:
  viz.scale.x = 1 if stats.facing == Z_PlayerStats.FACING.Right else -1

func _ready() -> void:
  if not stats:
    stats = Z_ComponentBase.resolve_from(self, Z_PlayerStats)
    stats.owner = self
  if not machine:
    machine = Z_ComponentBase.resolve_from(self, Z_PlayerStateMachine)
    machine.owner = self
  if Z_Config.player_auto_spawns_follow_camera_when_spawns:
    camera = Z_Path.group_main_camera_maybe_first_node()
    camera = camera if Z_Util.node_is_there(camera) else Z_FollowCamera.new()
    camera.target_node = self
    camera.zoom = Vector2(2,2)

    if not camera.is_inside_tree():
      __z.layer.player.add_child.call_deferred(camera)
  machine.start.call_deferred()

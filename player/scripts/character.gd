class_name Zaft_PlayerCharacter extends CharacterBody2D

@export var stats : Zaft_PlayerStats
@export var machine : Zaft_PlayerStateMachine

@onready var viz : Node2D = $V

var camera : Zaft_FollowCamera

static func becomes_ready() -> Zaft_PlayerCharacter:
  return await Zaft_Autoload_Path.await_for_first_node_in_group(Zaft_Autoload_Path.PLAYER_CHARACTER_GROUP)

func _enter_tree() -> void:
  add_to_group(Zaft_Autoload_Path.PLAYER_CHARACTER_GROUP)
  __zaft.global.register_player(self)

func _exit_tree() -> void:
  if __zaft.global.player == self:
    __zaft.global.register_player(null)

func _physics_process(_delta: float) -> void:
  viz.scale.x = 1 if stats.facing == Zaft_PlayerStats.FACING.Right else -1

func _ready() -> void:
  if not stats:
    stats = Zaft_ComponentBase.resolve_from(self, Zaft_PlayerStats)
    stats.owner = self
  if not machine:
    machine = Zaft_ComponentBase.resolve_from(self, Zaft_PlayerStateMachine)
    machine.owner = self
  if Zaft_Autoload_Config.player_auto_spawns_follow_camera_when_spawns:
    camera = Zaft_FollowCamera.new()
    camera.target_node = self
    __zaft.layer.player.add_child.call_deferred(camera)
  machine.start.call_deferred()

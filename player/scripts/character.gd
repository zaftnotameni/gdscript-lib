class_name Zaft_PlayerCharacter extends CharacterBody2D

@export var stats : Zaft_PlayerStats
@export var machine : Zaft_PlayerStateMachine

var camera : Zaft_FollowCamera

func _enter_tree() -> void:
  add_to_group(Zaft_Autoload_Path.PLAYER_CHARACTER_GROUP)
  __zaft.global.register_player(self)

func _exit_tree() -> void:
  if __zaft.global.player == self:
    __zaft.global.register_player(null)

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

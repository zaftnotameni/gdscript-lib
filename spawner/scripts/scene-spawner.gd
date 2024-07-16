class_name Zaft_SceneSpawner extends Node2D

@export_category('when')
@export var spawn_action_name : StringName
@export var uses_respawn_action : bool = false
@export var spawn_on_ready: bool = false
@export_category('how') 
@export var spawn_clears: bool = false
@export_category('what')
@export var scene : PackedScene
@export_category('where')
@export var layer : Zaft_Autoload_Layers.LAYERS
@export var container : Node2D
@export var spawned : Node2D

func spawn():
  assert(scene, 'missing scene at %s' % get_path())
  if spawn_clears and spawned and not spawned.is_queued_for_deletion():
    spawned.queue_free()
    await spawned.tree_exited
  var s := scene.instantiate()
  if container:
    container.add_child(s)
    if not container.is_inside_tree():
      __zaft.layer.layer_named(layer).add_child(s)
  else:
    __zaft.layer.layer_named(layer).add_child(s)
    s.global_position = global_position
  spawned = s

func _ready() -> void:
  if not spawn_action_name or spawn_action_name.is_empty():
    if uses_respawn_action: spawn_action_name = get_respawn_action()
  if spawn_on_ready:
    spawn()

func get_respawn_action():
  for a:StringName in RESPAWN_ACTIONS:
    if InputMap.has_action(a): return a

func _unhandled_input(event: InputEvent) -> void:
  if not spawn_action_name: return
  if event.is_action_pressed(spawn_action_name):
    spawn()

const RESPAWN_ACTIONS := [
  &'respawn',
  &'player-respawn',
  &'level-respawn',
  &'game-respawn',
]

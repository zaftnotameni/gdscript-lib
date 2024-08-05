class_name Z_SimpleSpawner extends Node2D

enum SPAWN_MODE { Ignore, SingleClear, SingleWarns }

signal sig_spawned(new_spawned:CanvasItem)
signal sig_despawned(despawned:CanvasItem)

@export_category('when')
@export var spawn_on_ready: bool = false
@export var free_on_exit: bool = false
@export_category('how')
@export var spawn_mode: SPAWN_MODE
@export_category('what')
## scene takes precedence of script
@export var scene_to_spawn : PackedScene
## script must be a CanvasItem, is ignored if scene is set
@export var script_to_spawn : Script
@export_category('where')
@export var layer : Z_Layers.LAYERS
@export var container : Node2D

var spawned_list : Array[CanvasItem] = []
var clearing := false

func clear_existing_spawned(wait_for_exit:=false):
  clearing = true
  for spawned:CanvasItem in spawned_list:
    if spawned and not spawned.is_queued_for_deletion():
      spawned.queue_free()
      if wait_for_exit: await spawned.tree_exited
  spawned_list.clear()
  clearing = false

func warn_if_existing_spawned():
  if not spawned_list.is_empty():
    push_warning('spawning item while expecting a single one to exist at %s' % get_path())

func remove_from_list(despawned:CanvasItem):
  if clearing: return
  spawned_list.erase(despawned)
  sig_despawned.emit(despawned)

func spawn():
  if not scene_to_spawn and not script_to_spawn:
    push_error('missing scene_to_spawn or script_to_spawn at %s' % get_path())
  if spawn_mode == SPAWN_MODE.SingleClear: await clear_existing_spawned(true)
  if spawn_mode == SPAWN_MODE.SingleWarns: warn_if_existing_spawned()
  var new_spawned : CanvasItem = scene_to_spawn.instantiate() if scene_to_spawn else script_to_spawn.new()
  var target_container := container if container else __z.layer.layer_named(layer)
  target_container.add_child(new_spawned)
  new_spawned.global_position = global_position
  spawned_list.push_back(new_spawned)
  sig_spawned.emit(new_spawned)
  new_spawned.tree_exited.connect(remove_from_list.bind(new_spawned), CONNECT_ONE_SHOT)

func _exit_tree() -> void: clear_existing_spawned()
func _ready() -> void: if spawn_on_ready: spawn()

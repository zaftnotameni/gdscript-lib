class_name Zaft_Autoload_Config extends Node

static var player_auto_spawns_follow_camera_when_spawns : bool = true
static var audio_uses_hacky_solution: bool = false

const TITLE_SCREEN_DEFAULT_FOCUS_BUTTON := ["test", "continue", "load", "start", "options", "about"]

var physics_layers_by_name := {}
var physics_layers_by_index := {}

func physics_layer_bit_by_name(layer_name:String='terrain', ignore_missing:= false) -> int:
  var idx := physics_layer_index_by_name(layer_name, ignore_missing)
  if idx <= 0: return idx
  return 2 ** (idx - 1)

func physics_layer_index_by_name(layer_name:String='terrain', ignore_missing:= false) -> int:
  if physics_layers_by_name.has(layer_name):
    return physics_layers_by_name[layer_name]
  if not ignore_missing:
    push_warning('attempted to access invalid layer by name %s', % layer_name)
  return -1

func physics_layer_name_by_index(layer_index:int=1, ignore_missing:= false) -> String:
  if physics_layers_by_index.has(layer_index):
    return physics_layers_by_index[layer_index]
  if not ignore_missing:
    push_warning('attempted to access invalid layer by index %s', % layer_index)
  return 'Invalid Layer'

func initialize_layers():
  for i in 32:
    var layer_index = i + 1
    var layer_name = ProjectSettings.get_setting('layer_names/2d_physics/layer_%s' % (layer_index))
    if layer_name and not layer_name.is_empty():
      physics_layers_by_name[layer_name] = layer_index
      physics_layers_by_index[layer_index] = layer_name

func _ready() -> void:
  initialize_layers()

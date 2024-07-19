class_name Zaft_Autoload_Config extends Node

enum INPUT_ACTIONS { Pause, Unpause, Back }

static var scene_menu_title: PackedScene
static var scene_menu_title_background: PackedScene

static var scene_menu_pause: PackedScene
static var scene_menu_pause_background: PackedScene

static var scene_menu_options: PackedScene
static var scene_menu_options_background: PackedScene

static var scene_menu_about: PackedScene
static var scene_menu_about_background: PackedScene

static var scene_menu_controls: PackedScene
static var scene_menu_controls_background: PackedScene

static var scene_menu_start: PackedScene
static var scene_menu_start_background: PackedScene

static var scene_menu_victory: PackedScene
static var scene_menu_victory_background: PackedScene

static var scene_menu_defeat: PackedScene
static var scene_menu_defeat_background: PackedScene

static var player_auto_spawns_follow_camera_when_spawns : bool = true

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

static func is_event_pause_pressed(event:InputEvent) -> bool: return is_event_action_pressed(event, INPUT_ACTIONS.Pause)
static func is_event_back_pressed(event:InputEvent) -> bool: return is_event_action_pressed(event, INPUT_ACTIONS.Back)
static func is_event_unpause_pressed(event:InputEvent) -> bool: return is_event_action_pressed(event, INPUT_ACTIONS.Unpause)
static func is_event_action_pressed(event:InputEvent, a:INPUT_ACTIONS) -> bool: return event.is_action_pressed(action_of(a))

static func action_of(a:INPUT_ACTIONS) -> StringName:
  var res : StringName = &'INVALID_ACTION'
  match a:
    INPUT_ACTIONS.Pause: res = &'pause'
    INPUT_ACTIONS.Unpause: res = &'menu-close'
    INPUT_ACTIONS.Back: res = &'menu-back'
  if not InputMap.has_action(res):
    push_error('action %s does not exist, define it on input map via %s' % [INPUT_ACTIONS.find_key(a), res])
  return res


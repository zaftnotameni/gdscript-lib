class_name Z_Config extends Resource

enum INPUT_ACTIONS { Pause, Unpause, Back }

static var player_height : int = 32
static var player_width : int = 32

static var screen_height : int = ProjectSettings.get_setting('display/window/size/viewport_height')
static var screen_width : int = ProjectSettings.get_setting('display/window/size/viewport_width')

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
static var disable_remote_leaderboard : bool = false

static var menu_background_color : Color = Color('#311b27')

static var physics_layers_by_name := {}
static var physics_layers_by_index := {}

static func physics_layer_bit_by_name(layer_name:String='terrain', ignore_missing:= false) -> int:
	var idx := physics_layer_index_by_name(layer_name, ignore_missing)
	if idx <= 0: return idx
	return 2 ** (idx - 1)

static func physics_layer_index_by_name(layer_name:String='terrain', ignore_missing:= false) -> int:
	if physics_layers_by_name.has(layer_name):
		return physics_layers_by_name[layer_name]
	if not ignore_missing:
		push_warning('attempted to access invalid layer by name %s' % layer_name)
	return -1

static func physics_layer_name_by_index(layer_index:int=1, ignore_missing:= false) -> String:
	if physics_layers_by_index.has(layer_index):
		return physics_layers_by_index[layer_index]
	if not ignore_missing:
		push_warning('attempted to access invalid layer by index %s' % layer_index)
	return 'Invalid Layer'

static func initialize_layers():
	for i in 32:
		var layer_index = i + 1
		var layer_name = ProjectSettings.get_setting('layer_names/2d_physics/layer_%s' % (layer_index))
		if layer_name and not layer_name.is_empty():
			physics_layers_by_name[layer_name] = layer_index
			physics_layers_by_index[layer_index] = layer_name

static func _static_init() -> void:
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


class_name Z_Global extends RefCounted

static var player : Node2D
static var camera : Camera2D
static var level : Node2D
static var menu : Control

static var rigid_player : RigidBody2D:
	get(): return player
static var kinematic_player : CharacterBody2D :
	get(): return player

static func register_player(v:Node2D) -> Node2D:
	if player == v: return
	var old_value = player
	player = v
	__z.bus.sig_global_player_set.emit(player, old_value)
	if player: player.tree_exited.connect(register_player.bind(null))
	return v

static func register_camera(v:Camera2D) -> Camera2D:
	if camera == v: return
	var old_value = camera
	camera = v
	__z.bus.sig_global_camera_set.emit(camera, old_value)
	if camera: camera.tree_exited.connect(register_camera.bind(null))
	return v

static func register_level(v:Node2D) -> Node2D:
	if level == v: return
	__z.bus.sig_global_level_set.emit(v,level)
	level = v
	if level: level.tree_exited.connect(register_level.bind(null))
	return v

static func register_menu(v:Control) -> Control:
	if menu == v: return
	__z.bus.sig_global_menu_set.emit(v, menu)
	menu = v
	if menu: menu.tree_exited.connect(register_menu.bind(null))
	return v

class_name Z_Global extends Node

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
  __z.bus.sig_player_set.emit(player, old_value)
  return v

static func register_camera(v:Camera2D) -> Camera2D:
  if camera == v: return
  var old_value = camera
  camera = v
  __z.bus.sig_camera_set.emit(camera, old_value)
  return v

static func register_level(v:Node2D) -> Node2D:
  if level == v: return
  __z.bus.sig_level_set.emit(v,level)
  level = v
  return v

static func register_menu(v:Control) -> Control:
  if menu == v: return
  __z.bus.sig_menu_set.emit(v, menu)
  menu = v
  return v

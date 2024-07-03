class_name Zaft_Autoload_Global extends Node

signal sig_player_set(new_player:CharacterBody2D,prev_player:CharacterBody2D)
signal sig_camera_set(new_cam:Camera2D,prev_cam:Camera2D)
signal sig_level_set(new_level:Node2D,prev_level:Node2D)
signal sig_menu_set(new_menu:Control,prev_menu:Control)

@export var player : CharacterBody2D
@export var camera : Camera2D
@export var level : Node2D
@export var menu : Control

func register_player(v:CharacterBody2D) -> CharacterBody2D:
  if player == v: return
  sig_player_set.emit(v, player)
  player = v
  return v

func register_camera(v:Camera2D) -> Camera2D:
  if camera == v: return
  sig_camera_set.emit(v, camera)
  camera = v
  return v

func register_level(v:Node2D) -> Node2D:
  if level == v: return
  sig_level_set.emit(v,level)
  level = v
  return v

func register_menu(v:Control) -> Control:
  if menu == v: return
  sig_menu_set.emit(v, menu)
  menu = v
  return v

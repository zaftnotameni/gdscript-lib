class_name Z_ConfigSetter extends Node

@export var scene_menu_title: PackedScene
@export var scene_menu_title_background: PackedScene
@export var scene_menu_pause: PackedScene
@export var scene_menu_pause_background: PackedScene
@export var scene_menu_options: PackedScene
@export var scene_menu_options_background: PackedScene
@export var scene_menu_about: PackedScene
@export var scene_menu_about_background: PackedScene
@export var scene_menu_controls: PackedScene
@export var scene_menu_controls_background: PackedScene
@export var scene_menu_start: PackedScene
@export var scene_menu_start_background: PackedScene
@export var scene_menu_victory: PackedScene
@export var scene_menu_victory_background: PackedScene
@export var scene_menu_defeat: PackedScene
@export var scene_menu_defeat_background: PackedScene
@export var player_auto_spawns_follow_camera_when_spawns : bool = true
@export var disable_remote_leaderboard : bool = false
@export var menu_background_color : Color = Color('#311b27')

func _ready() -> void:
	Z_Config.scene_menu_title = scene_menu_title
	Z_Config.scene_menu_title_background = scene_menu_title_background
	Z_Config.scene_menu_pause = scene_menu_pause
	Z_Config.scene_menu_pause_background = scene_menu_pause_background
	Z_Config.scene_menu_options = scene_menu_options
	Z_Config.scene_menu_options_background = scene_menu_options_background
	Z_Config.scene_menu_about = scene_menu_about
	Z_Config.scene_menu_about_background = scene_menu_about_background
	Z_Config.scene_menu_controls = scene_menu_controls
	Z_Config.scene_menu_controls_background = scene_menu_controls_background
	Z_Config.scene_menu_start = scene_menu_start
	Z_Config.scene_menu_start_background = scene_menu_start_background
	Z_Config.scene_menu_victory = scene_menu_victory
	Z_Config.scene_menu_victory_background = scene_menu_victory_background
	Z_Config.scene_menu_defeat = scene_menu_defeat
	Z_Config.scene_menu_defeat_background = scene_menu_defeat_background
	Z_Config.disable_remote_leaderboard = disable_remote_leaderboard 
	Z_Config.menu_background_color = menu_background_color 
	Z_Config.player_auto_spawns_follow_camera_when_spawns = player_auto_spawns_follow_camera_when_spawns 

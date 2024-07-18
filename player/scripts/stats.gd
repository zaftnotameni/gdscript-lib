class_name Zaft_PlayerStats extends Node

enum FACING { Right, Left }

# in %
@export var energy : int = 100
@export var fuel : int = 100

# directions
@export var facing : FACING

# in pixes
@export var player_width : int = 24
@export var player_height : int = 32

# in sec
@export var dash_duration : float = 0.1
@export var coyote_duration : float = 0.1

# in pixels/sec
@export var max_speed_from_input : int = player_width * 10
@export var initial_speed_from_input : int = max_speed_from_input
@export var dash_initial_speed : int = max_speed_from_input * 4

# in pixels/sec/sec
@export var acceleration_from_input : int = 128
@export var decceleration_from_lack_of_input : int = 2048

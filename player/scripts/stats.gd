class_name Z_PlayerStats extends Node

signal sig_facing_changed(player_stats:Z_PlayerStats)

enum FACING { Right, Left }

# directions
@export var facing : FACING

# in pxs
@export var jump_height : float = G_Settings.player_height * 2

## in secs
@export var dash_duration : float = 0.1
## in secs
@export var coyote_duration : float = 0.1
## in secs
@export var jump_time_to_peak : float = 0.4
## in secs
@export var jump_time_to_land : float = 0.3

## in pixels/sec
@export var max_speed_from_input : int = G_Settings.player_width * 10
## in pixels/sec
@export var max_speed_from_gravity : int = G_Settings.screen_height * 2
## in pixels/sec
@export var initial_speed_from_input : int = G_Settings.player_width * 5
## in pixels/sec
@export var dash_initial_speed : int = max_speed_from_input * 4

## in pixels/sec/sec
@export var acceleration_from_input : int = max_speed_from_input * 2
## in pixels/sec/sec
@export var decceleration_from_lack_of_input : int = max_speed_from_input * 16

var jump_velocity : float
var jump_gravity_up : float
var jump_gravity_down : float
var fall_gravity : float

func run_kinematic_equations():
  jump_velocity = (2.0 * jump_height) / jump_time_to_peak
  jump_gravity_up = (2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak)
  jump_gravity_down = (2.0 * jump_height) / (jump_time_to_land * jump_time_to_land)
  fall_gravity = (jump_gravity_up + jump_gravity_down) / 2.0

func _process(_delta:float) -> void:
  input_x = Z_PlayerInput.input_x()
  vel_x = player_velocity_x()
  compute_facing()

func _enter_tree() -> void:
  run_kinematic_equations()

func compute_facing() -> void:
  if is_player_pressing_left_or_right():
    update_facing(FACING.Right if input_x > 0 else FACING.Left)
  elif not is_zero_approx(vel_x):
    update_facing(FACING.Right if vel_x > 0 else FACING.Left)

func is_player_pressing_left_or_right() -> bool: return not is_zero_approx(input_x)
func player_velocity_x() -> float: return player.velocity.x
func update_facing(f:FACING) -> bool: return Z_Autoload_Util.setter(self, &'facing', f, sig_facing_changed)

# input
var input_x : float
var vel_x : float

@onready var player : Z_PlayerCharacter = owner


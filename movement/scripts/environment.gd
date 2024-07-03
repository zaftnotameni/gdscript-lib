class_name Zaft_Movement_Environment_Resource extends Resource

@export var player_size := Vector2(16.0, 16.0)
@export var max_velocity_value := 0.0
@export var max_velocity_axis : Vector2 = Vector2.ZERO
@export var multiplier_base := 1.0
@export var multiplier := 1.0
@export var acceleration := 0.0
@export var friction := 0.0
@export var gravity := 0.0
@export var jump_max := 1
@export var jump_height := 2.0 * player_size.y
@export var jump_time_to_peak := 0.4
@export var jump_time_to_land := 0.3
@export var jump_velocity := 0.0
@export var jump_gravity_up := 0.0
@export var jump_gravity_down := 0.0
@export var jump_inertia := 0.5

@export var base_max_velocity_value := 1.0
@export var base_max_velocity_axis := 0.75 * player_size
@export var base_acceleration := 1.0 * player_size.x
@export var base_friction := 1.0
@export var base_gravity := 1.0

func _init() -> void:
  recalculate()

func clamp_max_velocity_value(velocity:Vector2) -> Vector2:
  return velocity.limit_length(max_velocity_value)

func clamp_max_velocity_y_axis(velocity:Vector2) -> Vector2:
  if is_zero_approx(velocity.y): velocity.y = 0.0
  else: velocity.y = clampf(velocity.y, -max_velocity_axis.y, max_velocity_axis.y)
  return velocity

func clamp_max_velocity_x_axis(velocity:Vector2) -> Vector2:
  if is_zero_approx(velocity.x): velocity.x = 0.0
  else: velocity.x = clampf(velocity.x, -max_velocity_axis.x, max_velocity_axis.x)
  return velocity

func clamp_max_velocity_axis(velocity:Vector2) -> Vector2:
  if velocity.is_zero_approx(): return Vector2.ZERO 
  return velocity.clamp(-max_velocity_axis, max_velocity_axis)

func recalculate():
  max_velocity_axis = player_size * base_max_velocity_axis * multiplier * multiplier_base
  max_velocity_value = player_size.x * base_max_velocity_value * multiplier * multiplier_base
  acceleration = player_size.x * base_acceleration * multiplier * multiplier_base
  friction = player_size.y * base_friction * multiplier * multiplier_base
  kinematic_equations()

func kinematic_equations():
  jump_velocity = (2.0 * jump_height) / jump_time_to_peak
  jump_gravity_up = (2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak)
  jump_gravity_down = (2.0 * jump_height) / (jump_time_to_land * jump_time_to_land)
  gravity = (jump_gravity_up + jump_gravity_down) / 2.0

static func with(_player_size:=Vector2(16.0,16.0),_multiplier_base:=1.0) -> Zaft_Movement_Environment_Resource:
  var result = Zaft_Movement_Environment_Resource.new()
  result.player_size = _player_size
  result.multiplier_base = _multiplier_base
  result.recalculate()
  return result

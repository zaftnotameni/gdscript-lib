class_name Z_PlayerStateAirborne extends Z_PlayerStateMachineState

@onready var windrose : Z_PlayerWindrose = Z_ComponentBase.resolve_from(owner, Z_PlayerWindrose)
@onready var player : Z_PlayerCharacter = owner

func _unhandled_input(event: InputEvent) -> void:
  if via_transition == 'spawn-check':
    if Z_PlayerInput.event_is_dash_just_pressed(event):
      on_dash()

func on_dash():
  if player.stats.try_update_heat_relative(player.stats.heat_dash_cost_air):
    machine.transition('dash-air', STATE.Dashing)
  else:
    __zaft.audio.director.play_pitched_2d(sfx_deny, 1, true, false)
    __zaft.bus.sig_camera_trauma_request.emit(0.2)

func on_state_enter(_x=null):
  pass

func on_state_exit(_x=null):
  pass

func initial_speed_from_input(input_x:float) -> float: return input_x * character.stats.initial_speed_from_input
func is_same_direction_as_input(input_x:float) -> bool: return sign(input_x) == sign(character.velocity.x)
func is_under_initial_speed(initial_speed:float) -> bool: return abs(character.velocity.x) < abs(initial_speed)
func is_under_max_speed() -> bool: return abs(character.velocity.x) < abs(character.stats.max_speed_from_input)

func apply_gravity(delta:float):
  character.velocity.y += (character.stats.fall_gravity * delta)

func player_pressing_left_or_right(input_x: float, delta:float):
  var initial_speed = initial_speed_from_input(input_x)

  if is_same_direction_as_input(input_x):
    if is_under_initial_speed(initial_speed):
      character.velocity.x = initial_speed
    elif is_under_max_speed():
      character.velocity.x += input_x * character.stats.acceleration_from_input * delta
  else:
    character.velocity.x = initial_speed

func player_not_pressing_left_nor_right(_input_x: float, _delta:float):
  character.velocity.x = 0.0

func phys_proc_no_trans(delta: float) -> void:
  var input_x := Z_PlayerInput.input_ad_scalar()

  if input_x and not is_zero_approx(input_x):
    player_pressing_left_or_right(input_x, delta)
  else:
    player_not_pressing_left_nor_right(input_x, delta)

  apply_gravity(delta)
  character.move_and_slide()

func _physics_process(delta: float) -> void:
  phys_proc_no_trans(delta)

  if character.is_on_floor():
    machine.transition('landed', STATE.Grounded)
    return

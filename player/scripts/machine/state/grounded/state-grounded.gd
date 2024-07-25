class_name Z_PlayerStateGrounded extends Z_PlayerStateMachineState

@onready var windrose : Z_PlayerWindrose = Z_ComponentBase.resolve_from(owner, Z_PlayerWindrose)

func _unhandled_input(event: InputEvent) -> void:
  if Z_PlayerInput.event_is_dash_just_pressed(event):
    on_dash()

func on_state_enter(_prev:Z_StateMachineState):
  pass

func on_dash():
  machine.transition('dash-gnd', STATE.Dashing)

func initial_speed_from_input(input_x:float) -> float: return input_x * character.stats.initial_speed_from_input
func is_same_direction_as_input(input_x:float) -> bool: return sign(input_x) == sign(character.velocity.x)
func is_under_initial_speed(initial_speed:float) -> bool: return abs(character.velocity.x) < abs(initial_speed)
func is_under_max_speed() -> bool: return abs(character.velocity.x) < abs(character.stats.max_speed_from_input)

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

func phys_proc_no_trans(delta:float):
  var input_x := Z_PlayerInput.input_ad_scalar()

  if input_x and not is_zero_approx(input_x):
    player_pressing_left_or_right(input_x, delta)
  else:
    player_not_pressing_left_nor_right(input_x, delta)

  character.move_and_slide()

  if Z_PlayerInput.is_jump_pressed():
    machine.transition('jump', STATE.Jumping)

func _physics_process(delta: float) -> void:
  phys_proc_no_trans(delta)

  if not character.is_on_floor():
    machine.transition('coyoted', STATE.Coyoteing)

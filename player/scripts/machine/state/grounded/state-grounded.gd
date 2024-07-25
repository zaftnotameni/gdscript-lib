class_name Z_PlayerStateGrounded extends Z_PlayerStateMachineState

@onready var gravity_orientation : Z_PlayerGravityBasedOrientation = Z_ComponentBase.resolve_from(owner, Z_PlayerGravityBasedOrientation)
@onready var windrose : Z_PlayerWindrose = Z_ComponentBase.resolve_from(owner, Z_PlayerWindrose)

func _unhandled_input(event: InputEvent) -> void:
  if Z_PlayerInput.event_is_dash_just_pressed(event):
    on_dash()

func on_state_enter(_prev:Z_StateMachineState):
  pass
  # __zaft.bus.sig_camera_trauma_request.emit(0.1)

func on_dash():
  if not character.stats.update_energy_rel(-character.stats.energy_cons_dash_gnd): return

  machine.transition('dash-gnd', STATE.Dashing)

func update_facing_to_match(horz:Vector2):
  if horz.dot(windrose.right()) > 0:
    character.stats.facing = Z_PlayerStats.FACING.Right
  elif horz.dot(windrose.left()) > 0:
    character.stats.facing = Z_PlayerStats.FACING.Left

func update_velocity_to_match(horz:Vector2):
  character.velocity += horz
  if abs(character.velocity.dot(windrose.right())) > character.stats.max_speed_from_input:
    character.velocity += windrose.right() * (character.stats.max_speed_from_input - abs(character.velocity.dot(windrose.right()))) * sign(character.velocity.dot(windrose.right()))

func player_pressing_left_or_right(input_x: float, delta:float):
  var horz := windrose.right() * input_x * character.stats.initial_speed_from_input * delta
  update_facing_to_match(horz)
  update_velocity_to_match(horz)

func player_not_pressing_left_nor_right(_input_x: float, _delta:float):
  var lateral_velocity = character.velocity.dot(windrose.right())
  character.velocity -= windrose.right() * lateral_velocity

var max_jetpack_velocity : int = 512

func apply_jetpack(delta:float):
  if abs(character.velocity.dot(windrose.up())) < max_jetpack_velocity:
    character.velocity += windrose.up() * delta * 128

func phys_proc_no_trans(delta:float):
  var input_x := Z_PlayerInput.input_ad_scalar()

  if Z_PlayerInput.is_jump_pressed():
    apply_jetpack(delta)
    machine.transition('jetpack', STATE.Airborne)
  else:
    if input_x and not is_zero_approx(input_x):
      player_pressing_left_or_right(input_x, delta)
    else:
      player_not_pressing_left_nor_right(input_x, delta)

  character.move_and_slide()

func _physics_process(delta: float) -> void:
  phys_proc_no_trans(delta)

  if not character.is_on_floor():
    machine.transition('coyoted', STATE.Coyoteing)

class_name Z_PlayerStateJumping extends Z_PlayerStateActioned

@onready var windrose : Z_PlayerWindrose = Z_ComponentBase.resolve_from(owner, Z_PlayerWindrose)
@onready var player : Z_PlayerCharacter = owner
@onready var party_splash : CPUParticles2D = %PartyJumpSplash

var jump_cancelled : bool = false

func _unhandled_input(event: InputEvent) -> void:
  if Z_PlayerInput.event_is_jump_released(event):
    jump_cancelled = true
  if Z_PlayerInput.event_is_dash_just_pressed(event):
    on_dash()

func on_dash():
  if player.stats.try_update_heat_relative(player.stats.heat_dash_cost_air):
    machine.transition('dash-air', STATE.Dashing)

var t : Tween

func on_state_enter(_x=null):
  party_splash.emitting = true
  __zaft.audio.director.play_pitched_2d(sfx_jump, 1, true, false)
  character.velocity.y = -character.stats.jump_velocity
  character.move_and_slide()
  jump_cancelled = false
  t = Z_Autoload_Util.tween_fresh_eased_in_out_cubic(t)
  var sprite : Sprite2D = player.viz.get_node('Sprite2D')
  t.tween_property(sprite, 'scale:x', 0.8, 0.2)
  t.parallel().tween_property(sprite, 'scale:y', 1.2, 0.2)
  t.tween_property(sprite, 'scale:x', 1.0, 0.1)
  t.parallel().tween_property(sprite, 'scale:y', 1.0, 0.1)

func on_state_exit(_x=null):
  if t and t.is_running(): t.kill(); t = null
  jump_cancelled = false

func going_up() -> bool: return character.velocity.y < 0
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

func apply_gravity(delta:float):
  if jump_cancelled:
    character.velocity.y += (character.stats.jump_gravity_down * delta)
  elif going_up():
    character.velocity.y += (character.stats.jump_gravity_up * delta)
  else:
    character.velocity.y += (character.stats.jump_gravity_down * delta)

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
    __zaft.audio.director.play_pitched_2d(sfx_land, 1, true, false)
    machine.transition('landed', STATE.Grounded)

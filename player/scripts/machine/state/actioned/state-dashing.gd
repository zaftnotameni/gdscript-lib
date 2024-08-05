class_name Z_PlayerStateDashing extends Z_PlayerStateActioned

@onready var windrose : Z_PlayerWindrose = Z_ComponentBase.resolve_from(owner, Z_PlayerWindrose)
@onready var player : Z_PlayerCharacter = owner
@onready var party_dash_trail : CPUParticles2D = %PartyDashTrail
@onready var party_dash_splash : CPUParticles2D = %PartyDashSplash

var elapsed : float = 0.0

func on_state_exit(_prev:Z_StateMachineState):
  party_dash_trail.emitting = false
  party_dash_splash.emitting = false
  character.viz.skew = 0
  elapsed = 0.0

func on_state_enter(_prev:Z_StateMachineState):
  party_dash_trail.emitting = true
  party_dash_splash.emitting = true
  __z.audio.director.play_pitched_2d(sfx_dash, 1, true, false)
  match character.stats.facing:
    Z_PlayerStats.FACING.Right: character.viz.skew = deg_to_rad(-10)
    Z_PlayerStats.FACING.Left: character.viz.skew = deg_to_rad(10)
  elapsed = 0.0
  __z.bus.sig_camera_trauma_request.emit(0.2)

func dash_direction() -> Vector2:
  return windrose.right() if character.stats.facing == Z_PlayerStats.FACING.Right else windrose.left()

func _physics_process(delta: float) -> void:
  character.velocity = dash_direction() * character.stats.dash_initial_speed

  character.move_and_slide()

  elapsed += delta
  if Z_PlayerInput.is_jump_just_pressed():
    machine.transition('jump', STATE.Jumping)
    return
  if elapsed > 0.2 and not Z_PlayerInput.is_dash_pressed() and character.is_on_floor():
    machine.transition('dash-end-gnd', STATE.Grounded)
    return
  if elapsed > character.stats.dash_duration:
    if character.is_on_floor():
      machine.transition('dash-end-gnd', STATE.Grounded)
      return
    else:
      machine.transition('dash-end-air', STATE.Airborne)
      return


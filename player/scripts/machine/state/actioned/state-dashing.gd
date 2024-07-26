class_name Z_PlayerStateDashing extends Z_PlayerStateActioned

@onready var windrose : Z_PlayerWindrose = Z_ComponentBase.resolve_from(owner, Z_PlayerWindrose)

var elapsed : float = 0.0

func on_state_exit(_prev:Z_StateMachineState):
  elapsed = 0.0

func on_state_enter(_prev:Z_StateMachineState):
  elapsed = 0.0
  __zaft.bus.sig_camera_trauma_request.emit(0.2)

func dash_direction() -> Vector2:
  return windrose.right() if character.stats.facing == Z_PlayerStats.FACING.Right else windrose.left()

func _physics_process(delta: float) -> void:
  character.velocity = dash_direction() * character.stats.dash_initial_speed

  character.move_and_slide()

  elapsed += delta
  if elapsed > character.stats.dash_duration:
    if character.is_on_floor():
      machine.transition('dash-end-gnd', STATE.Grounded)
    else:
      machine.transition('dash-end-air', STATE.Airborne)


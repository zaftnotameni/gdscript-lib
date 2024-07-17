class_name Zaft_PlayerStateDashing extends Zaft_PlayerStateActioned

@onready var gravity_orientation : Zaft_PlayerGravityBasedOrientation = Zaft_ComponentBase.resolve_from(owner, Zaft_PlayerGravityBasedOrientation)
@onready var windrose : Zaft_PlayerWindrose = Zaft_ComponentBase.resolve_from(owner, Zaft_PlayerWindrose)

var elapsed : float = 0.0

func on_state_enter(_prev:Zaft_StateMachineState):
  elapsed = 0.0

func dash_direction() -> Vector2:
  return windrose.right() if character.stats.facing == Zaft_PlayerStats.FACING.Right else windrose.left()

func _physics_process(delta: float) -> void:
  character.velocity = dash_direction() * character.stats.dash_initial_speed

  character.move_and_slide()

  elapsed += delta
  if elapsed > character.stats.dash_duration:
    if character.is_on_floor():
      machine.transition('dash-end-gnd', STATE.Grounded)
    else:
      machine.transition('dash-end-air', STATE.Airborne)


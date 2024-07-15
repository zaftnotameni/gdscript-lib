class_name Zaft_PlayerStateMachineState extends Zaft_StateMachineState

@export var character : Zaft_PlayerCharacter
@export var machine : Zaft_PlayerStateMachine
@export var stats : Zaft_PlayerStats

func on_state_enter(_prev:Zaft_StateMachineState): pass
func on_state_exit(_next:Zaft_StateMachineState): pass

enum STATE {
  Initial = 0,
  Idling,
  Stilling,
  Walking,
  Running,
  Moving,
  Grounded,
  Falling,
  Ascending,
  Descending,
  Airborne,
  Jumping,
  Dashing,
  Rolling,
  Dodging,
  Actioned,
}

func _ready() -> void:
  if not Engine.is_editor_hint():
    if not character:
      character = owner
    if not stats:
      stats = Zaft_ComponentBase.resolve_from(character, Zaft_PlayerStats)
    if not machine:
      machine = Zaft_ComponentBase.resolve_from(character, Zaft_PlayerStateMachine)

static func type_of_state(s:Zaft_PlayerStateMachineState.STATE) -> Script:
  match s:
    Zaft_PlayerStateMachineState.STATE.Initial: return Zaft_PlayerStateInitial
    Zaft_PlayerStateMachineState.STATE.Idling: return Zaft_PlayerStateIdling
    Zaft_PlayerStateMachineState.STATE.Stilling: return Zaft_PlayerStateStilling
    Zaft_PlayerStateMachineState.STATE.Walking: return Zaft_PlayerStateWalking
    Zaft_PlayerStateMachineState.STATE.Running: return Zaft_PlayerStateRunning
    Zaft_PlayerStateMachineState.STATE.Moving: return Zaft_PlayerStateMoving
    Zaft_PlayerStateMachineState.STATE.Grounded: return Zaft_PlayerStateGrounded
    Zaft_PlayerStateMachineState.STATE.Falling: return Zaft_PlayerStateFalling
    Zaft_PlayerStateMachineState.STATE.Ascending: return Zaft_PlayerStateAscending
    Zaft_PlayerStateMachineState.STATE.Descending: return Zaft_PlayerStateDescending
    Zaft_PlayerStateMachineState.STATE.Airborne: return Zaft_PlayerStateAirborne
    Zaft_PlayerStateMachineState.STATE.Jumping: return Zaft_PlayerStateJumping
    Zaft_PlayerStateMachineState.STATE.Dashing: return Zaft_PlayerStateDashing
    Zaft_PlayerStateMachineState.STATE.Rolling: return Zaft_PlayerStateRolling
    Zaft_PlayerStateMachineState.STATE.Dodging: return Zaft_PlayerStateDodging
    Zaft_PlayerStateMachineState.STATE.Actioned: return Zaft_PlayerStateActioned
  return Zaft_PlayerStateMachineState

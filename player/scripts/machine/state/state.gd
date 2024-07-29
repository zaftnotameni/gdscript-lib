class_name Z_PlayerStateMachineState extends Z_StateMachineState

@export var blocks_facing_changes : bool
@export var character : Z_PlayerCharacter
@export var machine : Z_PlayerStateMachine
@export var stats : Z_PlayerStats

@onready var sfx_land : AudioStreamPlayer2D = %SfxLand
@onready var sfx_jump : AudioStreamPlayer2D = %SfxJump
@onready var sfx_dash : AudioStreamPlayer2D = %SfxDash
@onready var sfx_step : AudioStreamPlayer2D = %SfxLand
@onready var sfx_deny : AudioStreamPlayer2D = %SfxDeny
@onready var sfx_overheat : AudioStreamPlayer2D = %SfxLand

func on_state_enter(_prev:Z_StateMachineState): pass
func on_state_exit(_next:Z_StateMachineState): pass

enum STATE {
  Initial = 0,
  Idling,
  Stilling,
  Walking,
  Running,
  Moving,
  Coyoteing,
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
      stats = Z_ComponentBase.resolve_from(character, Z_PlayerStats)
    if not machine:
      machine = Z_ComponentBase.resolve_from(character, Z_PlayerStateMachine)

static func type_of_state(s:Z_PlayerStateMachineState.STATE) -> Script:
  match s:
    Z_PlayerStateMachineState.STATE.Initial: return Z_PlayerStateInitial
    Z_PlayerStateMachineState.STATE.Idling: return Z_PlayerStateIdling
    Z_PlayerStateMachineState.STATE.Stilling: return Z_PlayerStateStilling
    Z_PlayerStateMachineState.STATE.Walking: return Z_PlayerStateWalking
    Z_PlayerStateMachineState.STATE.Running: return Z_PlayerStateRunning
    Z_PlayerStateMachineState.STATE.Moving: return Z_PlayerStateMoving
    Z_PlayerStateMachineState.STATE.Coyoteing: return Z_PlayerStateCoyoteing
    Z_PlayerStateMachineState.STATE.Grounded: return Z_PlayerStateGrounded
    Z_PlayerStateMachineState.STATE.Falling: return Z_PlayerStateFalling
    Z_PlayerStateMachineState.STATE.Ascending: return Z_PlayerStateAscending
    Z_PlayerStateMachineState.STATE.Descending: return Z_PlayerStateDescending
    Z_PlayerStateMachineState.STATE.Airborne: return Z_PlayerStateAirborne
    Z_PlayerStateMachineState.STATE.Jumping: return Z_PlayerStateJumping
    Z_PlayerStateMachineState.STATE.Dashing: return Z_PlayerStateDashing
    Z_PlayerStateMachineState.STATE.Rolling: return Z_PlayerStateRolling
    Z_PlayerStateMachineState.STATE.Dodging: return Z_PlayerStateDodging
    Z_PlayerStateMachineState.STATE.Actioned: return Z_PlayerStateActioned
  return Z_PlayerStateMachineState

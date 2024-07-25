class_name Z_PlayerStateCoyoteing extends Z_PlayerStateGrounded

var elapsed : float = 0.0

func on_state_enter(_prev:Z_StateMachineState):
  elapsed = 0.0

func _physics_process(delta: float) -> void:
  phys_proc_no_trans(delta)

  elapsed += delta
  if character.is_on_floor():
    machine.transition('uncoyoted', STATE.Grounded)
  elif elapsed > character.stats.coyote_duration:
    machine.transition('fellout', STATE.Airborne)

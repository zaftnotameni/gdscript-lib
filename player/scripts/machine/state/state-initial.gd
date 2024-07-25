class_name Z_PlayerStateInitial extends Z_PlayerStateMachineState

func _physics_process(_delta: float) -> void:
  if character.is_on_floor():
    machine.transition('spawn-check', STATE.Grounded)
  else:
    machine.transition('spawn-check', STATE.Airborne)


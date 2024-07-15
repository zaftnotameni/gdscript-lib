class_name Zaft_PlayerStateInitial extends Zaft_PlayerStateMachineState

func _physics_process(_delta: float) -> void:
  print(_delta)
  if character.is_on_floor():
    machine.transition('spawn-check', STATE.Grounded)
  else:
    machine.transition('spawn-check', STATE.Airborne)


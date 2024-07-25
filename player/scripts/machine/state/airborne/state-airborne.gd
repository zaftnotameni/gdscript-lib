class_name Z_PlayerStateAirborne extends Z_PlayerStateMachineState

@onready var windrose : Z_PlayerWindrose = Z_ComponentBase.resolve_from(owner, Z_PlayerWindrose)

func _unhandled_input(_event: InputEvent) -> void:
  pass

func on_dash():
  machine.transition('dash-air', STATE.Dashing)

func on_state_enter(_x=null):
  pass

func on_state_exit(_x=null):
  pass

func apply_gravity(delta:float):
  character.velocity.y += (character.stats.fall_gravity * delta)

func _physics_process(delta: float) -> void:
  apply_gravity(delta)
  character.move_and_slide()

  if character.is_on_floor():
    machine.transition('landed', STATE.Grounded)

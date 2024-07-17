class_name Zaft_PlayerStateAirborne extends Zaft_PlayerStateMachineState

@onready var gravity_orientation : Zaft_PlayerGravityBasedOrientation = Zaft_ComponentBase.resolve_from(owner, Zaft_PlayerGravityBasedOrientation)
@onready var windrose : Zaft_PlayerWindrose = Zaft_ComponentBase.resolve_from(owner, Zaft_PlayerWindrose)

func _physics_process(delta: float) -> void:
  if gravity_orientation and gravity_orientation.gravity_source:
    character.velocity += gravity_orientation.gravity_source.gravity_strength * delta * windrose.down()

  character.move_and_slide()

  if character.is_on_floor():
    machine.transition('landed', STATE.Grounded)

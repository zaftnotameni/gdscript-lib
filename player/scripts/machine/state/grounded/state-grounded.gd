class_name Zaft_PlayerStateGrounded extends Zaft_PlayerStateMachineState

@onready var gravity_orientation : Zaft_PlayerGravityBasedOrientation = Zaft_ComponentBase.resolve_from(owner, Zaft_PlayerGravityBasedOrientation)
@onready var windrose : Zaft_PlayerWindrose = Zaft_ComponentBase.resolve_from(owner, Zaft_PlayerWindrose)

func _physics_process(delta: float) -> void:
  var input_x := Zaft_PlayerInput.input_ad_scalar()

  if input_x and not is_zero_approx(input_x):
    character.velocity += windrose.right() * input_x * character.stats.initial_speed_from_input * delta
    if abs(character.velocity.dot(windrose.right())) > character.stats.max_speed_from_input:
      character.velocity += windrose.right() * (character.stats.max_speed_from_input - abs(character.velocity.dot(windrose.right()))) * sign(character.velocity.dot(windrose.right()))
  else:
    var lateral_velocity = character.velocity.dot(windrose.right())
    character.velocity -= windrose.right() * lateral_velocity

  character.move_and_slide()

  if not character.is_on_floor():
    machine.transition('aired', STATE.Airborne)

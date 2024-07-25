class_name Z_PlayerStateJumping extends Z_PlayerStateActioned

@onready var windrose : Z_PlayerWindrose = Z_ComponentBase.resolve_from(owner, Z_PlayerWindrose)

var jump_cancelled : bool = false

func _unhandled_input(event: InputEvent) -> void:
  if Z_PlayerInput.event_is_jump_released(event):
    jump_cancelled = true

func on_dash():
  machine.transition('dash-air', STATE.Dashing)

func on_state_enter(_x=null):
  character.velocity.y = -character.stats.jump_velocity
  character.move_and_slide()
  jump_cancelled = false

func on_state_exit(_x=null):
  jump_cancelled = false

func going_up() -> bool: return character.velocity.y < 0

func apply_gravity(delta:float):
  if going_up():
    character.velocity.y += (character.stats.jump_gravity_up * delta)
  elif jump_cancelled:
    character.velocity.y += (character.stats.jump_gravity_down * delta)
  else:
    character.velocity.y += (character.stats.jump_gravity_down * delta)

func _physics_process(delta: float) -> void:
  apply_gravity(delta)
  character.move_and_slide()

  if character.is_on_floor():
    machine.transition('landed', STATE.Grounded)

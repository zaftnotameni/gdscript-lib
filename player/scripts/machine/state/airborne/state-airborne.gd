class_name Zaft_PlayerStateAirborne extends Zaft_PlayerStateMachineState

@onready var gravity_orientation : Zaft_PlayerGravityBasedOrientation = Zaft_ComponentBase.resolve_from(owner, Zaft_PlayerGravityBasedOrientation)
@onready var windrose : Zaft_PlayerWindrose = Zaft_ComponentBase.resolve_from(owner, Zaft_PlayerWindrose)
@onready var jetpack_particles : CPUParticles2D = %JetpackParticles

var max_jetpack_velocity : int = 512

func _unhandled_input(event: InputEvent) -> void:
  if Zaft_PlayerInput.event_is_dash_just_pressed(event):
    machine.transition('air-dash', STATE.Dashing)

func apply_jetpack(delta:float):
  jetpack_particles.emitting = true
  if abs(character.velocity.dot(windrose.up())) < max_jetpack_velocity:
    character.velocity += windrose.up() * delta * 128

func on_state_enter(_x=null):
  jetpack_particles.emitting = false

func on_state_exit(_x=null):
  jetpack_particles.emitting = false

func apply_gravity(delta:float):
  jetpack_particles.emitting = false
  character.velocity += gravity_orientation.gravity_source.gravity_strength * delta * windrose.down()

func _physics_process(delta: float) -> void:
  if Zaft_PlayerInput.is_jump_pressed():
    apply_jetpack(delta)
  elif gravity_orientation and gravity_orientation.gravity_source:
    apply_gravity(delta)

  character.move_and_slide()

  if character.is_on_floor():
    machine.transition('landed', STATE.Grounded)

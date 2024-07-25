class_name Z_PlayerStateAirborne extends Z_PlayerStateMachineState

@onready var gravity_orientation : Z_PlayerGravityBasedOrientation = Z_ComponentBase.resolve_from(owner, Z_PlayerGravityBasedOrientation)
@onready var windrose : Z_PlayerWindrose = Z_ComponentBase.resolve_from(owner, Z_PlayerWindrose)
@onready var jetpack_particles : CPUParticles2D = %JetpackParticles
@onready var jetpack_sfx : AudioStreamPlayer2D = %SfxJetpack
@onready var gun_reticle : Node2D = %RobotGunReticle

var max_jetpack_velocity : int = 512

func _unhandled_input(_event: InputEvent) -> void:
  pass
  #if Z_PlayerInput.event_is_dash_just_pressed(event):
  #  on_dash()

func on_dash():
  if not character.stats.update_fuel_rel(-character.stats.fuel_cons_dash_air): return

  machine.transition('dash-air', STATE.Dashing)

func jet_on():
  jetpack_particles.emitting = true
  __zaft.bus.sig_camera_trauma_request.emit(0.05, 0.2)
  __zaft.audio.director.play_pitched_2d(jetpack_sfx, 1, true)

func jet_off():
  jetpack_particles.emitting = false
  __zaft.bus.sig_camera_trauma_relief.emit(0.1)
  jetpack_sfx.stop()

func apply_jetpack(delta:float):
  if not character.stats.update_fuel_rel(-character.stats.fuel_cons_jetpack * delta): return

  jet_on()
  apply_jetpack_direction_of_pointing(delta)

func apply_jetpack_direction_of_pointing(delta:float):
  var dir := -(gun_reticle.global_position - character.global_position).normalized()
  if abs(character.velocity.dot(dir)) < max_jetpack_velocity:
    character.velocity += dir * delta * 128

func apply_jetpack_up_only_deprecated(delta:float):
  if abs(character.velocity.dot(windrose.up())) < max_jetpack_velocity:
    character.velocity += windrose.up() * delta * 128

func on_state_enter(_x=null):
  jet_off()

func on_state_exit(_x=null):
  jet_off()

func apply_gravity(delta:float):
  jet_off()
  character.velocity += gravity_orientation.gravity_source.gravity_strength * delta * windrose.down()

func _physics_process(delta: float) -> void:
  if Z_PlayerInput.is_jump_pressed():
    apply_jetpack(delta)
  elif gravity_orientation and gravity_orientation.gravity_source:
    apply_gravity(delta)

  character.move_and_slide()

  if character.is_on_floor():
    machine.transition('landed', STATE.Grounded)

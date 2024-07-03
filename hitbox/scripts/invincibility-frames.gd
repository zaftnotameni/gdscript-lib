class_name Zaft_InvincibilityFrames_Node extends Node

enum MODE { Physics = 0, Normal = 1 }

@export var mode : MODE
@export var target_node : Node2D
@export var duration : float = 0.1
@export var elapsed : float = 0.0
@export var sig_take_damage : StringName = &'sig_take_damage'
@export var material_node : Node2D
@export var shader_param : StringName = &'is_blinking'

var invincible := false

signal sig_invincibility_start()
signal sig_invincibility_end()

func _ready() -> void:
  elapsed = 0.0
  invincible = false
  if not target_node: target_node = get_parent()
  set_process(mode == MODE.Normal)
  set_physics_process(mode == MODE.Physics)
  assert(target_node.has_signal(sig_take_damage), '%s must have signal %s' % [target_node.get_path(), sig_take_damage])
  target_node.sig_take_damage.connect(on_damage_taken)

func update_shader_param():
  if material_node:
    if material_node.material:
      if material_node.material is ShaderMaterial:
        (material_node.material as ShaderMaterial).set_shader_parameter(shader_param, invincible)

func invincibility_ran_out():
  elapsed = 0.0
  invincible = false
  update_shader_param()
  sig_invincibility_end.emit()
  if target_node.has_method('disable_invincibility'):
    target_node.disable_invincibility()
  elif target_node.has_method('set_invincible'):
    target_node.set_invincible(invincible)
  elif 'invincible' in target_node:
    target_node.invincible = false

func on_damage_taken(_data:Zaft_Hit_Data):
  if not target_node: return
  elapsed = 0.0
  invincible = true
  update_shader_param()
  sig_invincibility_start.emit()
  if target_node.has_method('enable_invincibility'):
    target_node.enable_invincibility()
  elif target_node.has_method('set_invincible'):
    target_node.set_invincible(invincible)
  elif 'invincible' in target_node:
    target_node.invincible = true

func _physics_process(delta: float) -> void:
  do_process(delta)

func _process(delta: float) -> void:
  do_process(delta)

func do_process(delta:float):
  if invincible:
    elapsed += delta
    if elapsed > duration:
      invincibility_ran_out()

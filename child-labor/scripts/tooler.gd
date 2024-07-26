@tool
class_name Z_Tooler extends Node

const METHOD_ON_EDITOR_SAVE_SETUP := &'on_editor_save_setup'
const METHOD_ON_EDITOR_SAVE_CLEAR := &'on_editor_save_clear'

@export var setup_on_save : bool = false
@export var clear_on_save : bool = false
@export var setup : bool = false
@export var cleared : bool = false

@onready var tgt : Node = get_parent()

func _notification(what: int) -> void:
  if not Engine.is_editor_hint(): return
  if not is_inside_tree(): return
  if not owner: return
  if not get_tree(): return
  if not get_tree().edited_scene_root: return
  if not owner == get_tree().edited_scene_root: return
  if what == NOTIFICATION_EDITOR_PRE_SAVE:
    if not cleared and clear_on_save and tgt.has_method(METHOD_ON_EDITOR_SAVE_CLEAR):
      print_rich('running [b]%s[/b] at %s for tool clear' % [METHOD_ON_EDITOR_SAVE_CLEAR, owner.get_path_to(tgt)])
      setup = false
      cleared = true
      tgt.call(METHOD_ON_EDITOR_SAVE_CLEAR)
    if not setup and setup_on_save and tgt.has_method(METHOD_ON_EDITOR_SAVE_SETUP):
      print_rich('running [b]%s[/b] at %s for tool setup' % [METHOD_ON_EDITOR_SAVE_SETUP, owner.get_path_to(tgt)])
      setup = true
      cleared = false
      tgt.call(METHOD_ON_EDITOR_SAVE_SETUP)



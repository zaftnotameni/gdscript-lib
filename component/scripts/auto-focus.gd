class_name Z_AutoFocus extends Node

## defaults to parent
@export var target : Control

func _ready() -> void:
  if not target:
    if get_parent() is Control: target = get_parent()
  if not target:
    if owner is Control: target = owner
  if not target or not target.has_method(&'grab_focus'):
    push_error('could not find a valid target to focus at %s' % get_path())
  if target and target.has_method(&'grab_focus'):
    await get_tree().create_timer(0.02).timeout
    target.grab_focus.call_deferred()

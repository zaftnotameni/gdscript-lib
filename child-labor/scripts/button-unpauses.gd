@tool
class_name Z_ButtonUnpauses extends Node

## defaults to parent
@export var target : BaseButton

func on_pressed():
	__z.bus.sig_unpause_requested.emit()

func resolve_target():
	if not target:
		if get_parent() is BaseButton: target = get_parent()
	if not target:
		if owner is BaseButton: target = owner
	if not target or not target.has_signal(&'pressed'):
		push_error('could not find a valid target to target as an unpause button at %s' % get_path())

func _enter_tree() -> void: resolve_target()

func _ready() -> void:
	if Engine.is_editor_hint(): return
	resolve_target()
	target.pressed.connect(on_pressed)

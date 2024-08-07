@tool
class_name Z_PauseSceneController extends Node

func _enter_tree() -> void:
	owner.add_to_group(Z_Path.MENU_PAUSE)
	Z_ProcessAndPauseUtil.pause_always_process(self)
	Z_ProcessAndPauseUtil.pause_always_process(owner)
	if not Engine.is_editor_hint(): get_tree().paused = true

func _exit_tree() -> void:
	if not Engine.is_editor_hint(): get_tree().paused = false

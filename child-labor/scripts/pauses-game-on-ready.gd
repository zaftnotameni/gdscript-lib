@tool
class_name Z_PausesGameOnReady extends Node

func _enter_tree() -> void:
	process_mode = ProcessMode.PROCESS_MODE_ALWAYS

func _ready() -> void:
	if Engine.is_editor_hint(): return
	get_tree().paused = true

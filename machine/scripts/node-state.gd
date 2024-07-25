class_name Z_StateMachineState extends Node

@export var via_transition : String = "uninitialized-transition"
@export var via_state : String = "UninitializedState"

func on_state_enter(_prev:Z_StateMachineState): pass
func on_state_exit(_next:Z_StateMachineState): pass

func _enter_tree() -> void:
  if not Engine.is_editor_hint():
    process_mode = PROCESS_MODE_INHERIT
  if Engine.is_editor_hint():
    process_mode = PROCESS_MODE_DISABLED

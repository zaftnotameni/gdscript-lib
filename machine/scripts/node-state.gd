class_name Zaft_StateMachineState_Node extends Node

@export var via_transition : String = "uninitialized-transition"
@export var via_state : String = "UninitializedState"

func on_state_enter(_prev:Zaft_StateMachineState_Node): pass
func on_state_exit(_next:Zaft_StateMachineState_Node): pass

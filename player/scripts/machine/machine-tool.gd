@tool
class_name Zaft_PlayerStateMachineTool extends Node

@export var tooled : bool : set = set_tooled

func set_tooled(v:bool):
  if v == tooled: return
  tooled = v
  if Engine.is_editor_hint():
    if v: setup_tooled()
    else: clear_tooled()

func setup_tooled():
  for s:Zaft_PlayerStateMachineState.STATE in Zaft_PlayerStateMachineState.STATE.values():
    var t : Script = type_of_state(s)
    print(t, t.resource_path, t.resource_name)
    var c : Zaft_PlayerStateMachineState = t.new()
    c.name = Zaft_PlayerStateMachineState.STATE.find_key(s).to_pascal_case()
    Zaft_Autoload_Util.tool_add_child(target_state_machine(), c, owner)

func target_state_machine() -> Zaft_PlayerStateMachine:
  return Zaft_ComponentBase.resolve_at(get_parent(), Zaft_PlayerStateMachine)

func clear_tooled():
  for c in target_state_machine().get_children(): c.queue_free()

func type_of_state(s:Zaft_PlayerStateMachineState.STATE) -> Script:
  var the_name : String = Zaft_PlayerStateMachineState.STATE.find_key(s).to_snake_case()
  var custom_script : Script = get(&'custom_%s' % the_name)
  var default_script : Script = Zaft_PlayerStateMachineState.type_of_state(s)
  if custom_script:
    var base_script := custom_script.get_base_script()
    if base_script and base_script == default_script:
      print_verbose('custom script: %s, does match base type: %s, used for: %s. at: %s' % [custom_script.resource_path, default_script.resource_path, the_name, get_path()])
      return custom_script
    else:
      push_error('custom script: %s, does not match base type: %s, it extends %s instead. at: %s' % [custom_script.resource_path, default_script.resource_path, base_script.resource_path, get_path()])
  return default_script


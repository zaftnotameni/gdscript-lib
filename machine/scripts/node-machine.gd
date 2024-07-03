class_name Zaft_StateMachine extends Zaft_ComponentBase

signal sig_state_will_transition(_new:Zaft_StateMachineState_Node, _curr:Zaft_StateMachineState_Node, _prev:Zaft_StateMachineState_Node)
signal sig_state_did_transition(_curr:Zaft_StateMachineState_Node, _prev:Zaft_StateMachineState_Node)

enum MACHINE_MODE { Physics = 0, Normal }

@export var machine_mode: MACHINE_MODE
@export var state_curr: Zaft_StateMachineState_Node

var state_prev: Zaft_StateMachineState_Node

func validate(e:Dictionary) -> bool:
  assert(get_child_count() == e.size(), '%s does not match child count of %s' % [e, get_child_count()])
  for k:String in e.keys():
    assert(get_child(e[k]).name == k, 'expected child %s (%s) to be named %s' % [get_child(e[k]).name, e[k], k])
  return true

func start():
  assert(state_curr, 'missing current state')
  assert(state_prev, 'missing previous state')
  state_curr.via_state = 'MachineStarted'
  state_curr.via_transition = 'machine-start'
  state_prev.via_state = 'MachineStarted'
  state_prev.via_transition = 'machine-start'
  call_deferred('enable_processing',state_curr)

func transition(via:="Transition Name",index:int=0):
  var next := state_by_index(index)
  assert(next, 'next state is invalid during transition %s (%s)' % [via,index])
  assert(state_curr, 'current state is invalid during transition %s (%s)' % [via,index])

  setup_next(next, via)
  sig_state_will_transition.emit(next, state_curr, state_prev)

  state_curr.on_state_exit(next)
  disable_processing(state_curr)
  next_curr_prev(next)
  next.on_state_enter(state_prev)
  enable_processing(next)

  sig_state_did_transition.emit(state_curr, state_prev)

func setup_next(next:Zaft_StateMachineState_Node,via:="Transition Name"):
  next.via_state = state_curr.name
  next.via_transition = via

func next_curr_prev(next:Zaft_StateMachineState_Node):
  state_prev = state_curr
  state_curr = next

func _enter_tree() -> void:
  add_to_group(__zaft.path.PLAYER_CHARACTER_STATE_MACHINE_GROUP)

func state_by_index(_state_index:int=0) -> Zaft_StateMachineState_Node:
  return get_child(_state_index)

func state_by_name(_state_name:String="State Name") -> Zaft_StateMachineState_Node:
  return get_node(_state_name)

func _ready() -> void:
  super()
  if not state_curr: state_curr = get_child(0)
  if not state_prev: state_prev = state_curr
  disable_processing(self)
  for c:Node in get_children(): disable_processing(c)

func enable_processing(n:Node=self):
  if not n: return
  n.set_physics_process(machine_mode == MACHINE_MODE.Physics)
  n.set_process(machine_mode == MACHINE_MODE.Normal)
  n.set_process_input(true)
  n.set_process_shortcut_input(true)
  n.set_process_unhandled_input(true)
  n.set_process_unhandled_key_input(true)

func disable_processing(n:Node=self):
  if not n: return
  n.set_physics_process(false)
  n.set_process(false)
  n.set_process_input(false)
  n.set_process_shortcut_input(false)
  n.set_process_unhandled_input(false)
  n.set_process_unhandled_key_input(false)

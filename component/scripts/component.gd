class_name Zaft_ComponentBase extends Node

enum PROCESS_USING { Physics = 0, Normal = 1, None = -1 }
const GROUP := &'components'
const DEFAULT_COMPONENT_LOCATION := ^'C'

## defaults to owner if not set
@export var target_node : Node = owner
@export var process_using : PROCESS_USING = PROCESS_USING.None

static func matches_type(node:Node,typ:Script=Zaft_ComponentBase) -> bool:
  var s := node.get_script() as Script
  if not s: return false
  return s == typ

static func resolve_from(node:Node,typ:Script=Zaft_ComponentBase,selector:NodePath=DEFAULT_COMPONENT_LOCATION,ignore_missing:=false) -> Node:
  assert(node, 'must provide a node')
  assert(node.is_inside_tree(), 'node must be in the tree')
  assert(node.has_node(selector), '%s must have a %s node' % [node.get_path(), selector])
  return resolve_at(node.get_node(selector), typ, ignore_missing)

static func resolve_at(node:Node,typ:Script=Zaft_ComponentBase,ignore_missing:=false) -> Node:
  assert(node, 'must provide a node')
  assert(node.is_inside_tree(), 'node must be in the tree')
  for c in node.get_children():
    if matches_type(c,typ): return c
  if ignore_missing:
    return null
  else:
    push_warning('tried to resolve missing component %s at %s' % [typ, node.get_path()])
    return null

func resolve_from_owner(typ:Script=Zaft_ComponentBase, selector:NodePath=DEFAULT_COMPONENT_LOCATION, ignore_missing:=false) -> Node:
  return resolve_from(owner, typ, selector, ignore_missing)

func resolve_from_target(typ:Script=Zaft_ComponentBase, selector:NodePath=DEFAULT_COMPONENT_LOCATION, ignore_missing:=false) -> Node:
  return resolve_from(target_node, typ, selector, ignore_missing)

func resolve_at_owner(typ:Script=Zaft_ComponentBase, selector:NodePath=^'.', ignore_missing:=false) -> Node:
  return resolve_from(owner, typ, selector, ignore_missing)

func resolve_at_target(typ:Script=Zaft_ComponentBase, selector:NodePath=^'.', ignore_missing:=false) -> Node:
  return resolve_from(target_node, typ, selector, ignore_missing)

func resolve_sibling(typ:Script=Zaft_ComponentBase, selector:NodePath=^'.', ignore_missing:=false) -> Node:
  return resolve_from(get_parent(), typ, selector, ignore_missing)

func _ready() -> void:
  if not target_node: target_node = owner
  assert(target_node, '%s must have a target_node' % get_path())
  set_process(process_using == PROCESS_USING.Normal)
  set_physics_process(process_using == PROCESS_USING.Physics)

func component_process(_delta:float) -> void:
  push_warning('%s should implement component_process(delta:float)' % get_path())

func _physics_process(delta: float) -> void:
  component_process(delta)

func _process(delta: float) -> void:
  component_process(delta)

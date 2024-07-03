class_name Zaft_ComponentBase extends Node

enum PROCESS_USING { Physics = 0, Normal = 1, None = -1 }
const GROUP := &'components'

## defaults to owner if not set
@export var target_node : Node = owner
@export var process_using : PROCESS_USING = PROCESS_USING.Physics

static func is_component(node:Node,typ:Script=Zaft_ComponentBase) -> bool:
  var s := node.get_script() as Script
  if not s: return false
  return s == typ

static func resolve_from(node:Node,typ:Script=Zaft_ComponentBase,selector:NodePath='Components',ignore_missing:=false) -> Zaft_ComponentBase:
  assert(node, 'must provide a node')
  assert(node.is_inside_tree(), 'node must be in the tree')
  assert(node.has_node(selector), '%s must have a %s node' % [node.get_path(), selector])
  return resolve_at(node.get_node(selector), typ, ignore_missing)

static func resolve_at(node:Node,typ:Script=Zaft_ComponentBase,ignore_missing:=false) -> Zaft_ComponentBase:
  assert(node, 'must provide a node')
  assert(node.is_inside_tree(), 'node must be in the tree')
  for c in node.get_children():
    if is_component(c,typ): return c
  if ignore_missing:
    return null
  else:
    push_warning('tried to resolve missing component %s at %s' % [typ, node.get_path()])
    return null

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

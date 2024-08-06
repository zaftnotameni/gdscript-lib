class_name Z_ComponentBase extends Node

enum PROCESS_USING { Physics = 0, Normal = 1, None = -1 }
const GROUP := &'components'

## defaults to owner if not set
@export var target_node : Node = owner
@export var process_using : PROCESS_USING = PROCESS_USING.None

const DEFAULT_COMPONENT_LOCATION := ^'C'

func resolve_from_owner(typ:Script=Z_ComponentBase, selector:NodePath=DEFAULT_COMPONENT_LOCATION, ignore_missing:=false) -> Node:
  return Z_ResolveUtil.resolve_from(owner, typ, selector, ignore_missing)

func resolve_from_target(typ:Script=Z_ComponentBase, selector:NodePath=DEFAULT_COMPONENT_LOCATION, ignore_missing:=false) -> Node:
  return Z_ResolveUtil.resolve_from(target_node, typ, selector, ignore_missing)

func resolve_at_owner(typ:Script=Z_ComponentBase, selector:NodePath=^'.', ignore_missing:=false) -> Node:
  return Z_ResolveUtil.resolve_from(owner, typ, selector, ignore_missing)

func resolve_at_target(typ:Script=Z_ComponentBase, selector:NodePath=^'.', ignore_missing:=false) -> Node:
  return Z_ResolveUtil.resolve_from(target_node, typ, selector, ignore_missing)

func resolve_sibling(typ:Script=Z_ComponentBase, selector:NodePath=^'.', ignore_missing:=false) -> Node:
  return Z_ResolveUtil.resolve_from(get_parent(), typ, selector, ignore_missing)

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

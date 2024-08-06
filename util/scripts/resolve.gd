class_name Z_ResolveUtil extends RefCounted

static func matches_type(node:Node,typ:Script=Z_ComponentBase) -> bool:
	var s := node.get_script() as Script
	if not s: return false
	return s == typ

const DEFAULT_COMPONENT_LOCATION := ^'C'

static func resolve_from(node:Node,typ:Script=Z_ComponentBase,selector:NodePath=DEFAULT_COMPONENT_LOCATION,ignore_missing:=false) -> Node:
	assert(node, 'must provide a node')
	assert(node.is_inside_tree(), 'node must be in the tree')
	assert(node.has_node(selector), '%s must have a %s node' % [node.get_path(), selector])
	return resolve_at(node.get_node(selector), typ, ignore_missing)

static func resolve_at(node:Node,typ:Script=Z_ComponentBase,ignore_missing:=false) -> Node:
	assert(node, 'must provide a node')
	assert(node.is_inside_tree(), 'node must be in the tree')
	for c in node.get_children():
		if matches_type(c,typ): return c
	if ignore_missing:
		return null
	else:
		push_warning('tried to resolve missing component %s at %s' % [typ, node.get_path()])
		return null


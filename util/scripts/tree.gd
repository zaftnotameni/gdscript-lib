class_name Z_TreeUtil extends RefCounted

static func scene_tree() -> SceneTree: return Engine.get_main_loop()
static func current_scene() -> Node: return Engine.get_main_loop().current_scene

static func tree_node_at_root(node:Node) -> Node:
	var scn : Node = scene_tree().root
	if node.is_inside_tree(): return node
	if node.has_meta('singleton_instance_setup') and node.get_meta('singleton_instance_setup'): return node
	node.set_meta('singleton_instance_setup', true)
	var script:Script = node.get_script()
	if script and script.get_global_name(): node.name = script.get_global_name()
	scn.add_child.call_deferred(node)
	return node

static func singleton(TypeScript:Script) -> Node:
	var existing = TypeScript['_instance']; if existing: return existing
	var instance = TypeScript.new(); TypeScript['_instance'] = instance
	return tree_node_at_root(instance)

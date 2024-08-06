@tool
class_name Z_ToolScriptHelper extends Node

static func on_pre_save(what: int, fn:Callable) -> void: if what == NOTIFICATION_EDITOR_PRE_SAVE: await fn.call()

static func tool_add_child(parent:Node, child:Node):
	if not is_valid_tool_target(parent): return
	parent.add_child.call_deferred(child)
	await child.ready
	child.set_meta('created_via_tool_script', true)
	child.owner = parent.get_tree().edited_scene_root

static func is_valid_tool_target(node:Node) -> bool:
	if not node: return false
	if not node.get_tree(): return false
	if not Engine.is_editor_hint(): return false
	if node.is_part_of_edited_scene(): return true
	if node.get_tree().edited_scene_root == node: return true
	return false

static func remove_all_children_created_via_tool_from(node:Node):
	if not is_valid_tool_target(node): return
	for child:Node in node.get_children():
		if not child.has_meta('created_via_tool_script'): continue
		if not child.get_meta('created_via_tool_script'): continue
		child.queue_free()
		await child.tree_exited

static func remove_all_children_dangerously_from(node:Node):
	if not is_valid_tool_target(node): return
	for child:Node in node.get_children():
		child.queue_free()
		await child.tree_exited

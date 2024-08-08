@tool
class_name Z_AreaFollowsMouse extends Area2D

func _notification(what: int) -> void: Z_ToolScriptHelper.on_pre_save(what, on_pre_save)

func on_pre_save():
	if not Z_ToolScriptHelper.is_owned_by_edited_scene(self): return
	await Z_ToolScriptHelper.remove_all_children_created_via_tool_from(self)
	if get_child_count() > 0: return
	var shape := CollisionShape2D.new()
	shape.shape = CircleShape2D.new()
	shape.shape.radius = 8
	await Z_ToolScriptHelper.tool_add_child(self, shape)

func _process(_delta: float) -> void:
	if Engine.is_editor_hint(): return
	var viewport := get_viewport()
	var camera := viewport.get_camera_2d()
	global_position = camera.get_global_mouse_position() if camera else viewport.get_mouse_position()

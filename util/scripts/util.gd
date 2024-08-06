class_name Z_Util extends RefCounted

static func scene_tree() -> SceneTree: return Engine.get_main_loop()

static func timer_bump(t:Timer, only_if_running:=false) -> Timer:
	if not t: return t
	if t.is_stopped() and only_if_running: return t
	t.stop()
	t.start()
	return t

static func node_is_there(_node) -> bool:
	return _node and is_instance_valid(_node) and not _node.is_queued_for_deletion()

static func children_wipe(_node:Node,_exceptions:Array[Node]=[]) -> Node:
	if node_is_there(_node): for child in _node.get_children(): if not _exceptions.has(child):
		child.queue_free()
	return _node

static func children_make_all_invisible(_node:Node):
	if node_is_there(_node): for child in _node.get_children(): child.visible = false

static func children_make_all_visible(_node:Node):
	if node_is_there(_node): for child in _node.get_children(): child.visible = true

static func string_format_time(time_seconds: float) -> String:
	if time_seconds <= 0: return '--:--:--.---'
	var total_seconds = int(time_seconds)
	var milliseconds = int((time_seconds - total_seconds) * 1000)
	
	var seconds = total_seconds % 60
	@warning_ignore(&'integer_division')
	var minutes = (total_seconds / 60) % 60
	@warning_ignore(&'integer_division')
	var hours = total_seconds / 3600

	var formatted_time = "%02d:%02d:%02d.%03d" % [hours, minutes, seconds, milliseconds]
	
	return formatted_time

static func raycast_from_to(from_glopos:Vector2, to_glopos:Vector2) -> Dictionary:
	var raycast_params := PhysicsRayQueryParameters2D.new()
	raycast_params.from = from_glopos
	raycast_params.to = to_glopos
	var st : SceneTree = scene_tree()
	var ci : CanvasItem = st.current_scene
	var world : World2D = ci.get_world_2d()
	var phys : PhysicsDirectSpaceState2D = world.direct_space_state
	var result := phys.intersect_ray(raycast_params)
	return result


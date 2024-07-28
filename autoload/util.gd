class_name Z_Autoload_Util extends Node

static func setter(o:Object,k:StringName,v:Variant,s:Signal) -> bool:
  if not o: return false
  var val = o.get(k)
  if val == v: return false
  o.set(k,v) 
  if s: s.emit(v,val)
  return true

static func setter_float_relative(o:Object,k:StringName,delta:Variant,s:Signal) -> bool:
  if not o: return false
  var old_val = o.get(k)
  if is_zero_approx(delta): return false
  var new_val = old_val + delta
  o.set(k, new_val) 
  if s: s.emit(new_val,old_val)
  return true

static func setter_float(o:Object,k:StringName,v:Variant,s:Signal) -> bool:
  if not o: return false
  var val = o.get(k)
  if is_equal_approx(val, v): return false
  o.set(k,v) 
  if s: s.emit(v,val)
  return true

static func scene_tree() -> SceneTree:
  return Engine.get_main_loop()

static func tool_add_child_to_scene_root(child:Node):
  if not child: return
  if Engine.is_editor_hint():
    scene_tree().edited_scene_root.add_child(child)
    child.owner = scene_tree().edited_scene_root

static func tool_add_child(parent:Node,child:Node,custom_owner:Node=parent):
  if not parent: return
  if not child: return
  parent.add_child(child)
  if custom_owner:
    child.owner = custom_owner
  elif Engine.is_editor_hint():
    if not parent.get_tree(): return
    child.owner = parent.get_tree().get_edited_scene_root()

static func timer_bump(t:Timer, only_if_running:=false) -> Timer:
  if not t: return t
  if t.is_stopped() and only_if_running: return t
  t.stop()
  t.start()
  return t

static func debug_dict_to_debug_str(d:Dictionary)->String:return var_to_str(d)\
  .replace("{","").replace("}","").replace('"',"").replace(",\n","\n").replace("Vector2", "").strip_edges()

static func debug_is_script_var(prop:Dictionary) -> bool:
  return prop.get('type') == TYPE_OBJECT and prop.get('usage') == PROPERTY_USAGE_SCRIPT_VARIABLE

static func tween_kill(t:Tween):
  if t and t.is_running(): t.kill()

static func tween_fresh(t:Tween=scene_tree().create_tween(),always_kill:=true)->Tween:
  if t and (always_kill or t.is_running()):
    t.kill()
  t = scene_tree().create_tween()
  t.set_pause_mode(Tween.TweenPauseMode.TWEEN_PAUSE_BOUND)
  return t

static func tween_eased_in_out_cubic(t:Tween=scene_tree().create_tween())->Tween:
  t.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
  t.set_pause_mode(Tween.TweenPauseMode.TWEEN_PAUSE_BOUND)
  return t

static func tween_fresh_eased_in_out_cubic(t:Tween=scene_tree().create_tween(),always_kill:=true)->Tween:
  t = tween_fresh(t,always_kill)
  t.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
  t.set_pause_mode(Tween.TweenPauseMode.TWEEN_PAUSE_BOUND)
  return t

static func control_set_margin(con:MarginContainer,margin:int=0):
  con.add_theme_constant_override(&'margin_left', margin)
  con.add_theme_constant_override(&'margin_right', margin)
  con.add_theme_constant_override(&'margin_top', margin)
  con.add_theme_constant_override(&'margin_bottom', margin)

static func control_set_bottom_right_min_size(con:Control):
  con.set_anchors_and_offsets_preset(Control.LayoutPreset.PRESET_BOTTOM_RIGHT, Control.LayoutPresetMode.PRESET_MODE_MINSIZE)

static func control_set_hshrink_center(con:Control):
  con.size_flags_horizontal = Control.SizeFlags.SIZE_SHRINK_CENTER

static func control_set_center_min_size(con:Control):
  con.set_anchors_and_offsets_preset(Control.LayoutPreset.PRESET_CENTER, Control.LayoutPresetMode.PRESET_MODE_MINSIZE)

static func control_set_top_left_min_size(con:Control):
  con.set_anchors_and_offsets_preset(Control.LayoutPreset.PRESET_TOP_LEFT, Control.LayoutPresetMode.PRESET_MODE_MINSIZE)

static func control_set_top_right_min_size(con:Control):
  con.set_anchors_and_offsets_preset(Control.LayoutPreset.PRESET_TOP_RIGHT, Control.LayoutPresetMode.PRESET_MODE_MINSIZE)

static func control_set_color(con:Control,col:Color=Color.HOT_PINK):
  con.add_theme_color_override("font_color",col)

static func control_set_font_size(con:Control,size:int=32):
  con.add_theme_font_size_override("font_size", size)

static func control_set_minimum_x(con:Control,x:float=100.0):
  con.custom_minimum_size.x = x

static func control_set_minimum_y(con:Control,y:float=100.0):
  con.custom_minimum_size.y = y

static func pause_never_process(_b:Node):
  _b.process_mode = Node.PROCESS_MODE_DISABLED

static func pause_always_process(_b:Node):
  _b.process_mode = Node.PROCESS_MODE_ALWAYS

static func pause_respects_pause(_b:Node):
  _b.process_mode = Node.PROCESS_MODE_PAUSABLE

static func pause_inherits(_b:Node):
  _b.process_mode = Node.PROCESS_MODE_INHERIT

static func node_turn_off(_b:Node):
  if not _b: return
  _b.hide()
  _b.process_mode = Node.PROCESS_MODE_DISABLED

static func node_turn_on(_b:Node):
  if not _b: return
  _b.process_mode = Node.PROCESS_MODE_INHERIT
  _b.show()

static func node_is_there(_node) -> bool:
  return _node and is_instance_valid(_node) and not _node.is_queued_for_deletion()

static func node_safe_qfree(_node:Node):
  if node_is_there(_node):
    _node.queue_free()

## _parent: node that as a property with name _name that contains a value of type node,
## that node will be add as a child of the _parent
static func node_add_prop_named_as_child_named(_name:String,_parent:Node) -> Node:
  if _parent.has_node(_name): printerr("node %s already has a child named %s" % [_parent, _name])
  var child := _parent.get(_name) as Node
  child.name = _name.to_pascal_case()
  _parent.add_child(child)
  return child

static func node_add_child_named(_parent:Node,_child:Node,_name:String) -> Node:
  if _parent.has_node(_name): printerr("node %s already has a child named %s" % [_parent, _name])
  _child.name = _name.to_pascal_case()
  _parent.add_child(_child)
  return _child

static func phys_moin(_b:Node2D,phys:=false,proc:=false,ing:=true,able:=true):
  if not _b: return
  _b.visible = true
  _b.process_mode = Node.PROCESS_MODE_INHERIT
  _b.set_deferred('monitoring', ing)
  _b.set_deferred('monitorable', able)
  _b.set_deferred('freeze', false)
  _b.set_deferred('sleeping', false)
  _b.call_deferred('set_physics_process', phys)
  _b.call_deferred('set_process', proc)

static func phys_zzz(_b:Node2D):
  if not _b: return
  _b.visible = false
  _b.process_mode = Node.PROCESS_MODE_DISABLED
  _b.call_deferred('set_physics_process', false)
  _b.call_deferred('set_process', false)
  _b.set_deferred('velocity', Vector2.ZERO)
  _b.set_deferred('linear_velocity', Vector2.ZERO)
  _b.set_deferred('angular_velocity', Vector2.ZERO)
  _b.set_deferred('monitoring', false)
  _b.set_deferred('monitorable', false)
  _b.set_deferred('freeze', true)
  _b.set_deferred('sleeping', true)

static func children_wipe(_node:Node,_exceptions:Array[Node]=[]) -> Node:
  if node_is_there(_node):
    for child in _node.get_children():
      if not _exceptions.has(child):
        child.queue_free()
  return _node

static func children_make_all_invisible(_node:Node):
  if node_is_there(_node):
    for child in _node.get_children():
      child.visible = false

static func children_make_all_visible(_node:Node):
  if node_is_there(_node):
    for child in _node.get_children():
      child.visible = true

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

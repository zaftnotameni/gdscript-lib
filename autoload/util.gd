class_name Zaft_Autoload_Util extends Node

static func tool_add_child(parent:Node,child:Node):
  if not parent: return
  if not child: return
  parent.add_child(child)
  if Engine.is_editor_hint():
    if not parent.get_tree(): return
    child.owner = parent.get_tree().get_edited_scene_root()
  else:
    child.owner = parent

var for_timer := ForTimer.new(self)
class ForTimer:
  var its : Zaft_Autoload_Util
  func _init(_its:Zaft_Autoload_Util): its = _its
  func bump(t:Timer,only_if_running:=false) -> Timer:
    if not t: return t
    if t.is_stopped() and only_if_running: return t
    t.stop()
    t.start()
    return t

var for_debug := ForDebug.new(self)
class ForDebug:
  var its : Zaft_Autoload_Util
  func _init(_its:Zaft_Autoload_Util): its = _its
  func dict_to_debug_str(d:Dictionary)->String:return var_to_str(d)\
    .replace("{","").replace("}","").replace('"',"").replace(",\n","\n").replace("Vector2", "").strip_edges()

  func is_script_var(prop:Dictionary) -> bool:
    return prop.get('type') == TYPE_OBJECT and prop.get('usage') == PROPERTY_USAGE_SCRIPT_VARIABLE

var for_tween := ForTween.new(self)
class ForTween:
  var its : Zaft_Autoload_Util
  func _init(_its:Zaft_Autoload_Util): its = _its

  func fresh(t:Tween,always_kill:=false)->Tween:
    if t and (always_kill or t.is_running()): t.kill()
    t = its.create_tween()
    return t

  func eased_in_out_cubic(t:Tween,always_kill:=false)->Tween:
    t = fresh(t,always_kill)
    t.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
    return t

var for_vector := ForVector.new(self)
class ForVector:
  var its : Zaft_Autoload_Util
  func _init(_its:Zaft_Autoload_Util): its = _its

  func x_input(a:="player-left",d:="player-right")->float:
    return Input.get_axis(a,d)

  func y_input(w:="player-up",s:="player-down")->float:
    return Input.get_axis(w,s)

  func wasd_input(w:="player-up",a:="player-left",s:="player-down",d:="player-right")->Vector2:
    return Vector2(Input.get_axis(a,d),Input.get_axis(w,s))

  func y_only(v:Vector2)->Vector2:return Vector2(0.0, v.y)
  func x_only(v:Vector2)->Vector2:return Vector2(v.x, 0.0)

var for_control := ForControl.new(self)
class ForControl:
  var its : Zaft_Autoload_Util
  func _init(_its:Zaft_Autoload_Util): its = _its

  func set_color(con:Control,col:Color=Color.HOT_PINK):
    con.add_theme_color_override("font_color",col)

  func set_font_size(con:Control,size:int=32):
    con.add_theme_font_size_override("font_size", size)

  func set_minimum_x(con:Control,x:float=100.0):
    con.custom_minimum_size.x = x

  func set_minimum_y(con:Control,y:float=100.0):
    con.custom_minimum_size.y = y

var for_node := ForNode.new(self)
class ForNode:
  var its : Zaft_Autoload_Util
  func _init(_its:Zaft_Autoload_Util): its = _its

  func turn_off(_b:Node2D):
    if not _b: return
    _b.hide()
    _b.process_mode = Node.PROCESS_MODE_DISABLED

  func turn_on(_b:Node2D):
    if not _b: return
    _b.process_mode = Node.PROCESS_MODE_INHERIT
    _b.show()

  func is_there(_node:Node) -> bool:
    return _node != null and is_instance_valid(_node) and not _node.is_queued_for_deletion()

  func safe_free(_node:Node):
    if its.for_node.is_there(_node):
      _node.queue_free()

  func add_prop_named_as_child_named(_name:String,_parent:Node) -> Node:
    if _parent.has_node(_name): printerr("node %s already has a child named %s" % [_parent, _name])
    var child := _parent.get(_name) as Node
    child.name = _name.to_pascal_case()
    _parent.add_child(child)
    return child

  func add_child_named(_parent:Node,_child:Node,_name:String) -> Node:
    if _parent.has_node(_name): printerr("node %s already has a child named %s" % [_parent, _name])
    _child.name = _name.to_pascal_case()
    _parent.add_child(_child)
    return _child

var for_phys := ForPhys.new(self)
class ForPhys:
  var its : Zaft_Autoload_Util
  func _init(_its:Zaft_Autoload_Util): its = _its

  func moin(_b:Node2D,phys:=false,proc:=false,ing:=true,able:=true):
    if not _b: return
    _b.visible = true
    _b.process_mode = Node.PROCESS_MODE_INHERIT
    _b.set_deferred('monitoring', ing)
    _b.set_deferred('monitorable', able)
    _b.set_deferred('freeze', false)
    _b.set_deferred('sleeping', false)
    _b.call_deferred('set_physics_process', phys)
    _b.call_deferred('set_process', proc)

  func zzz(_b:Node2D):
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

var for_child := ForChild.new(self)
class ForChild:
  var its : Zaft_Autoload_Util
  func _init(_its:Zaft_Autoload_Util): its = _its

  func wipe_except(_node:Node,_exceptions:Array[Node]=[]) -> Node:
    if its.for_node.is_there(_node):
      for child in _node.get_children():
        if not _exceptions.has(child):
          child.queue_free()
    return _node

  func make_all_invisible(_node:Node): if _node != null: for child in _node.get_children(): child.visible = false
  func make_all_visible(_node:Node): if _node != null: for child in _node.get_children(): child.visible = true

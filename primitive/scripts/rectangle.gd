@tool
class_name Z_Primitive_Rectangle extends Node2D

@export var width : float = 32
@export var height : float = 32
## if centered, only width and height are used
@export var centered : bool = false
@export var color : Color = Color.HOT_PINK
@export var filled : bool = true
@export var use_polygon : bool = false
## if rect is given, width, height, centered, top, and left are all ignored
@export_group('optional')
@export_subgroup('rect')
@export var rect : Rect2
@export_subgroup('top/left')
@export var top : float = -16
@export var left : float = -16

func points_for_polygon() -> PackedVector2Array:
  var ps := []
  var rec := resolve_rect()
  for t:Array in [[0,0],[0,1],[1,1],[1,0],[0,0]]:
    ps.push_back(rec.position + Vector2(t[0] * rec.size.x, t[1] * rec.size.y))
  return PackedVector2Array(ps)

func setup_polygon():
  for c in get_children(): if c is Polygon2D and c.name == 'PrimitiveRectPoly': c.name = 'DeleteMePlease'; c.queue_free()
  var poly := Polygon2D.new()
  poly.name = 'PrimitiveRectPoly'
  poly.polygon = points_for_polygon()
  poly.uv = Z_PolygonUtil.uv_for_vertexes(poly.polygon)
  poly.color = color
  Z_Autoload_Util.tool_add_child.call_deferred(self, poly)

func set_as_centered_rect():
  var half_width := width / 2;
  var half_height := height / 2;
  top = -half_height
  left = -half_width

func resolve_rect() -> Rect2:
  if rect: return rect
  else:
    if centered: set_as_centered_rect()
    return Rect2(left, top, width, height)

func _notification(what: int) -> void:
  if not Engine.is_editor_hint(): return
  if not is_inside_tree(): return
  if not owner: return
  if not get_tree(): return
  if not get_tree().edited_scene_root: return
  if not owner == get_tree().edited_scene_root: return
  if what == NOTIFICATION_EDITOR_PRE_SAVE:
    if not use_polygon: queue_redraw()
    if use_polygon: setup_polygon()

func _draw() -> void:
  if use_polygon: return
  draw_rect(resolve_rect(), color, filled)

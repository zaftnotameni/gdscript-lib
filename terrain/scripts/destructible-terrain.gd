class_name Z_DestructibleTerrain extends Node2D

@export_category('features')
@export var no_occluder := false
@export var enable_areas := false
@export var enable_polys := true
@export var enable_bodys := true

@export_category('parents')
@export var areas : Node2D
@export var polys : Node2D
@export var bodys : Node2D

## initial seed of polygons, each entry in the array is a counterclockwise poly
@export var parrs : Array[PackedVector2Array]

func _ready() -> void:
  if not areas: areas = Node2D.new(); add_child(areas)
  if not polys: polys = Node2D.new(); add_child(polys); polys.use_parent_material = true
  if not bodys: bodys = Node2D.new(); add_child(bodys)
  if not parrs: parrs = []
  validate_parrs()
  apply_all_deferred()

func replace_parrs(new_parrs:Array[PackedVector2Array]):
  parrs = new_parrs
  clear_all_deferred()
  apply_all_deferred()

func check_terrain_intersecting_with_parr(parr_a:PackedVector2Array) -> bool:
  for parr_b in parrs:
    var iparrarr := Geometry2D.intersect_polygons(parr_a,parr_b)
    if not iparrarr.is_empty(): return true
  return false

func add_terrain_intersecting_with_parr(parr:PackedVector2Array):
  var new_parrs := poly_a_arr_plus_b_to_array(parrs.duplicate(), parr)
  replace_parrs(new_parrs)

func remove_terrain_intersecting_with_parr(parr:PackedVector2Array):
  var new_parrs := poly_a_arr_minus_b_to_array(parrs.duplicate(), parr)
  replace_parrs(new_parrs)

func grow_terrain_intersecting_with_parr(parr:PackedVector2Array, px:int):
  var intersects := check_terrain_intersecting_with_parr(parr)
  if not intersects: return
  var new_parrs := grow_polys_by_pixels(parrs.duplicate(), px)
  replace_parrs(new_parrs)

func poly_a_arr_plus_b_to_array(aarr:Array[PackedVector2Array],b:PackedVector2Array,result:Array[PackedVector2Array]=[]) -> Array[PackedVector2Array]:
  if not aarr or aarr.is_empty(): return result
  for a in aarr:
    if poly_a_plus_b_to_array(a,b,result):
      break
  return result

func grow_polys_by_pixels(aarr:Array[PackedVector2Array],px:=1,result:Array[PackedVector2Array]=[]) -> Array[PackedVector2Array]:
  if not aarr or aarr.is_empty(): return result
  for a in aarr:
    for r in Geometry2D.offset_polygon(a, px):
      result.push_back(r)
  return result


func poly_a_arr_minus_b_to_array(aarr:Array[PackedVector2Array],b:PackedVector2Array,result:Array[PackedVector2Array]=[]) -> Array[PackedVector2Array]:
  if not aarr or aarr.is_empty(): return result
  for a in aarr:
    poly_a_minus_b_to_array(a,b,result)
  return result

func poly_a_plus_b_to_array(a:PackedVector2Array,b:PackedVector2Array,result:Array[PackedVector2Array]=[]) -> bool:
  if not a or a.is_empty(): return false
  if not b or b.is_empty(): return false
  var iparrarr := Geometry2D.intersect_polygons(a,b)
  if iparrarr and not iparrarr.is_empty():
    var marrarr := Geometry2D.merge_polygons(a,b)
    poly_arr_arr_to_array(marrarr, result)
    return true
  else:
    poly_arr_to_array(a, result)
    return false

func poly_a_minus_b_to_array(a:PackedVector2Array,b:PackedVector2Array,result:Array[PackedVector2Array]=[]):
  if not a or a.is_empty(): return
  if not b or b.is_empty(): return
  for parr in Geometry2D.clip_polygons(a,b):
    var iparrarr := Geometry2D.intersect_polygons(parr,a)
    poly_arr_arr_to_array(iparrarr, result)

func poly_arr_arr_to_array(parrarr:Array[PackedVector2Array],result:Array[PackedVector2Array]=[]):
  if not parrarr or parrarr.is_empty(): return
  for parr in parrarr:
    poly_arr_to_array(parr, result)

func poly_arr_arr_to_polys(parrarr:Array[PackedVector2Array],the_parent:Node):
  if not parrarr or parrarr.is_empty(): return
  for parr in parrarr:
    poly_arr_to_poly(parr, the_parent)

func poly_arr_arr_to_areas(parrarr:Array[PackedVector2Array],the_parent:Node):
  if not parrarr or parrarr.is_empty(): return
  for parr in parrarr:
    poly_arr_to_area(parr, the_parent)

func poly_arr_arr_to_bodys(parrarr:Array[PackedVector2Array],the_parent:Node):
  if not parrarr or parrarr.is_empty(): return
  for parr in parrarr:
    poly_arr_to_body(parr, the_parent)

func poly_arr_to_array(parr:PackedVector2Array,result:Array[PackedVector2Array]=[]):
  if not parr or parr.is_empty(): return
  result.push_back(parr)

func uv_for_vertexes(v0:PackedVector2Array=[]) -> PackedVector2Array:
  var x0 = INF
  var y0 = INF
  var x1 = -INF
  var y1 = -INF
  for v in v0:
    x0 = min(x0, v.x)
    x1 = max(x1, v.x)
    y0 = min(y0, v.y)
    y1 = max(y1, v.y)
  var s = max(x1 - x0, y1 - y0)
  var d = Vector2(s / 2, s / 2);
  var uv = []
  for v in v0:
    uv.append((v + d) / s)
  return PackedVector2Array(uv)

func calculate_uvs(vertices: Array) -> Array:
  var min_x = INF
  var min_y = INF
  var max_x = -INF
  var max_y = -INF

  for vertex in vertices:
    if vertex.x < min_x:
      min_x = vertex.x
    if vertex.y < min_y:
      min_y = vertex.y
    if vertex.x > max_x:
      max_x = vertex.x
    if vertex.y > max_y:
      max_y = vertex.y

  var width = max_x - min_x
  var height = max_y - min_y

  var uvs = []
  for vertex in vertices:
    var uv_x = (vertex.x - min_x) / width
    var uv_y = (vertex.y - min_y) / height
    uvs.push_back(Vector2(uv_x, uv_y))

  return uvs

func poly_arr_to_poly(parr:PackedVector2Array,the_parent:Node):
  if not parr or parr.is_empty(): return
  var p := Polygon2D.new()
  var op := OccluderPolygon2D.new()
  var tex := PlaceholderTexture2D.new()
  tex.size = Vector2(1, 1)
  p.texture_repeat = CanvasItem.TEXTURE_REPEAT_ENABLED
  p.texture = tex
  p.color = Color.WHITE
  p.use_parent_material = true
  p.polygon = parr
  p.uv = PackedVector2Array(calculate_uvs(parr))
  op.polygon = parr
  the_parent.add_child(p)
  if not no_occluder:
    var o := LightOccluder2D.new()
    o.occluder = op
    p.add_child(o)

func poly_arr_to_body(parr:PackedVector2Array,the_parent:Node):
  if not parr or parr.is_empty(): return
  var b := StaticBody2D.new()
  for m in get_meta_list():
    b.set_meta(m, get_meta(m))
  var p := CollisionPolygon2D.new()
  p.polygon = parr
  b.add_child(p)
  the_parent.add_child(b)

func poly_arr_to_area(parr:PackedVector2Array,the_parent:Node):
  if not parr or parr.is_empty(): return
  var a := Area2D.new()
  var p := CollisionPolygon2D.new()
  for m in get_meta_list():
    a.set_meta(m, get_meta(m))
  p.polygon = parr
  a.add_child(p)
  the_parent.add_child(a)

func poly_to_bodys(poly:Polygon2D,the_parent:Node=poly):
  if not poly: return
  var parrarr := Geometry2D.decompose_polygon_in_convex(poly.polygon)
  poly_arr_arr_to_bodys(parrarr, the_parent)

func poly_to_areas(poly:Polygon2D,the_parent:Node=poly):
  if not poly: return
  var parrarr := Geometry2D.decompose_polygon_in_convex(poly.polygon)
  poly_arr_arr_to_areas(parrarr, the_parent)

func apply_all_deferred(): apply_polys.call_deferred(); apply_bodys.call_deferred(); apply_areas.call_deferred();
func apply_areas(): poly_arr_arr_to_areas(parrs,areas)
func apply_polys(): poly_arr_arr_to_polys(parrs,polys)
func apply_bodys(): poly_arr_arr_to_bodys(parrs,bodys)

func clear_all_deferred(): clear_polys_deferred(); clear_bodys_deferred(); clear_areas_deferred();
func clear_areas_deferred(): Z_Util.children_wipe.call_deferred(areas)
func clear_polys_deferred(): Z_Util.children_wipe.call_deferred(polys)
func clear_bodys_deferred(): Z_Util.children_wipe.call_deferred(bodys)

func validate_parrs():
  for parr:PackedVector2Array in parrs:
    if not parr or parr.is_empty() or Geometry2D.is_polygon_clockwise(parr):
      push_warning('parr must be a counterclockwise polygon at %s' % get_path())


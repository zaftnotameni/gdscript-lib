class_name Zaft_DestructibleTerrain extends Node2D

@export_category('features')
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

func add_terrain_intersecting_with_parr(parr:PackedVector2Array):
  var new_parrs := poly_a_arr_plus_b_to_array(parrs.duplicate(), parr)
  replace_parrs(new_parrs)

func remove_terrain_intersecting_with_parr(parr:PackedVector2Array):
  var new_parrs := poly_a_arr_minus_b_to_array(parrs.duplicate(), parr)
  replace_parrs(new_parrs)

static func poly_a_arr_plus_b_to_array(aarr:Array[PackedVector2Array],b:PackedVector2Array,result:Array[PackedVector2Array]=[]) -> Array[PackedVector2Array]:
  if not aarr or aarr.is_empty(): return result
  for a in aarr:
    if poly_a_plus_b_to_array(a,b,result):
      break
  return result

static func poly_a_arr_minus_b_to_array(aarr:Array[PackedVector2Array],b:PackedVector2Array,result:Array[PackedVector2Array]=[]) -> Array[PackedVector2Array]:
  if not aarr or aarr.is_empty(): return result
  for a in aarr:
    poly_a_minus_b_to_array(a,b,result)
  return result

static func poly_a_plus_b_to_array(a:PackedVector2Array,b:PackedVector2Array,result:Array[PackedVector2Array]=[]) -> bool:
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

static func poly_a_minus_b_to_array(a:PackedVector2Array,b:PackedVector2Array,result:Array[PackedVector2Array]=[]):
  if not a or a.is_empty(): return
  if not b or b.is_empty(): return
  for parr in Geometry2D.clip_polygons(a,b):
    var iparrarr := Geometry2D.intersect_polygons(parr,a)
    poly_arr_arr_to_array(iparrarr, result)

static func poly_arr_arr_to_array(parrarr:Array[PackedVector2Array],result:Array[PackedVector2Array]=[]):
  if not parrarr or parrarr.is_empty(): return
  for parr in parrarr:
    poly_arr_to_array(parr, result)

static func poly_arr_arr_to_polys(parrarr:Array[PackedVector2Array],the_parent:Node):
  if not parrarr or parrarr.is_empty(): return
  for parr in parrarr:
    poly_arr_to_poly(parr, the_parent)

static func poly_arr_arr_to_areas(parrarr:Array[PackedVector2Array],the_parent:Node):
  if not parrarr or parrarr.is_empty(): return
  for parr in parrarr:
    poly_arr_to_area(parr, the_parent)

static func poly_arr_arr_to_bodys(parrarr:Array[PackedVector2Array],the_parent:Node):
  if not parrarr or parrarr.is_empty(): return
  for parr in parrarr:
    poly_arr_to_body(parr, the_parent)

static func poly_arr_to_array(parr:PackedVector2Array,result:Array[PackedVector2Array]=[]):
  if not parr or parr.is_empty(): return
  result.push_back(parr)

static func poly_arr_to_poly(parr:PackedVector2Array,the_parent:Node):
  if not parr or parr.is_empty(): return
  var p := Polygon2D.new()
  var tex := PlaceholderTexture2D.new()
  tex.size = Vector2(512, 512)
  p.texture_repeat = CanvasItem.TEXTURE_REPEAT_ENABLED
  p.texture = tex
  p.color = Color.WHITE
  p.use_parent_material = true
  p.polygon = parr
  the_parent.add_child(p)

static func poly_arr_to_body(parr:PackedVector2Array,the_parent:Node):
  if not parr or parr.is_empty(): return
  var b := StaticBody2D.new()
  var p := CollisionPolygon2D.new()
  p.polygon = parr
  b.add_child(p)
  the_parent.add_child(b)

static func poly_arr_to_area(parr:PackedVector2Array,the_parent:Node):
  if not parr or parr.is_empty(): return
  var a := Area2D.new()
  var p := CollisionPolygon2D.new()
  p.polygon = parr
  a.add_child(p)
  the_parent.add_child(a)

static func poly_to_bodys(poly:Polygon2D,the_parent:Node=poly):
  if not poly: return
  var parrarr := Geometry2D.decompose_polygon_in_convex(poly.polygon)
  poly_arr_arr_to_bodys(parrarr, the_parent)

static func poly_to_areas(poly:Polygon2D,the_parent:Node=poly):
  if not poly: return
  var parrarr := Geometry2D.decompose_polygon_in_convex(poly.polygon)
  poly_arr_arr_to_areas(parrarr, the_parent)

func apply_all_deferred(): apply_polys.call_deferred(); apply_bodys.call_deferred(); apply_areas.call_deferred();
func apply_areas(): poly_arr_arr_to_areas(parrs,areas)
func apply_polys(): poly_arr_arr_to_polys(parrs,polys)
func apply_bodys(): poly_arr_arr_to_bodys(parrs,bodys)

func clear_all_deferred(): clear_polys_deferred(); clear_bodys_deferred(); clear_areas_deferred();
func clear_areas_deferred(): Zaft_Autoload_Util.children_wipe.call_deferred(areas)
func clear_polys_deferred(): Zaft_Autoload_Util.children_wipe.call_deferred(polys)
func clear_bodys_deferred(): Zaft_Autoload_Util.children_wipe.call_deferred(bodys)

func validate_parrs():
  for parr:PackedVector2Array in parrs:
    if not parr or parr.is_empty() or Geometry2D.is_polygon_clockwise(parr):
      push_warning('parr must be a counterclockwise polygon at %s' % get_path())


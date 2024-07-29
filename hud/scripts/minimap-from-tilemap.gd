@tool
class_name Z_MinimapFromTilemap extends ColorRect

@export var tilemap_layer : TileMapLayer
@export var tile_color : Color = Color.HOT_PINK

func _draw() -> void:
  var tm := tilemap_layer
  var ts := tm.tile_set;
  var max_x : float = -INF
  var max_y : float = -INF
  var min_x : float = INF
  var min_y : float = INF
  for cell in tm.get_used_cells():
    var cell_center_in_tilemap_local_coords := tm.map_to_local(cell)
    if cell_center_in_tilemap_local_coords.x < min_x: min_x = cell_center_in_tilemap_local_coords.x
    if cell_center_in_tilemap_local_coords.y < min_y: min_y = cell_center_in_tilemap_local_coords.y
    if cell_center_in_tilemap_local_coords.x > max_x: max_x = cell_center_in_tilemap_local_coords.x
    if cell_center_in_tilemap_local_coords.y > max_y: max_y = cell_center_in_tilemap_local_coords.y
  for cell in tm.get_used_cells():
    var cell_center_in_tilemap_local_coords := tm.map_to_local(cell)
    var remaped_center_x : float = remap(cell_center_in_tilemap_local_coords.x, min_x, max_x, ts.tile_size.x, size.x - ts.tile_size.x)
    var remaped_center_y : float = remap(cell_center_in_tilemap_local_coords.y, min_y, max_y, ts.tile_size.y, size.y - ts.tile_size.y)
    var remaped_center := Vector2(remaped_center_x, remaped_center_y)
    var original_range := Vector2(max_x - min_x, max_y - min_y)
    var new_range := Vector2(size.x - ts.tile_size.x - ts.tile_size.x, size.y - ts.tile_size.y - ts.tile_size.y)
    var ratio_range := Vector2(new_range.x / original_range.x, new_range.y / original_range.y)
    var remaped_size := Vector2(ts.tile_size.x * ratio_range.x, ts.tile_size.y * ratio_range.y)
    var rect = Rect2(remaped_center - (remaped_size * 0.5), remaped_size)
    draw_rect(rect, tile_color, true)
 
func on_editor_save_setup():
  tilemap_layer = Z_ComponentBase.resolve_at(owner, Z_BasicTilemapLayer)
  queue_redraw()

func on_editor_save_clear():
  pass

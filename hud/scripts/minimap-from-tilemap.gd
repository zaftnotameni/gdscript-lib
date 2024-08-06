@tool
class_name Z_MinimapFromTilemap extends ColorRect

@export var tilemap_layer : TileMapLayer
@export var tile_color : Color = Color.HOT_PINK
@export var change_width_to_match_ratio : bool = false

var max_tm_x : float = -INF
var max_tm_y : float = -INF
var min_tm_x : float = INF
var min_tm_y : float = INF

func _ready() -> void:
	compute_tm_boundaries()

func compute_tm_boundaries_if_needed():
	if not tilemap_layer: return

	if max_tm_x == -INF: compute_tm_boundaries(); return
	if max_tm_y == -INF: compute_tm_boundaries(); return
	if min_tm_x == INF: compute_tm_boundaries(); return
	if min_tm_y == INF: compute_tm_boundaries(); return

func compute_tm_boundaries():
	if not tilemap_layer: return

	var tm := tilemap_layer
	for cell in tm.get_used_cells():
		var cell_center_in_tilemap_local_coords := tm.map_to_local(cell)
		if cell_center_in_tilemap_local_coords.x < min_tm_x: min_tm_x = cell_center_in_tilemap_local_coords.x
		if cell_center_in_tilemap_local_coords.y < min_tm_y: min_tm_y = cell_center_in_tilemap_local_coords.y
		if cell_center_in_tilemap_local_coords.x > max_tm_x: max_tm_x = cell_center_in_tilemap_local_coords.x
		if cell_center_in_tilemap_local_coords.y > max_tm_y: max_tm_y = cell_center_in_tilemap_local_coords.y

func _draw() -> void:
	if not tilemap_layer: return

	compute_tm_boundaries()
	var tm := tilemap_layer
	var ts := tm.tile_set;
	var the_size := size
	var original_range := Vector2(max_tm_x - min_tm_x, max_tm_y - min_tm_y)
	if change_width_to_match_ratio:
		the_size.x = the_size.y * (original_range.x / original_range.y)
	var new_range := Vector2(the_size.x - ts.tile_size.x - ts.tile_size.x, the_size.y - ts.tile_size.y - ts.tile_size.y)
	var ratio_range := Vector2(new_range.x / original_range.x, new_range.y / original_range.y)
	var remaped_size := Vector2(ts.tile_size.x * ratio_range.x, ts.tile_size.y * ratio_range.y)
	for cell in tm.get_used_cells():
		var cell_center_in_tilemap_local_coords := tm.map_to_local(cell)
		var remaped_center_x : float = remap(cell_center_in_tilemap_local_coords.x, min_tm_x, max_tm_x, ts.tile_size.x, the_size.x - ts.tile_size.x)
		var remaped_center_y : float = remap(cell_center_in_tilemap_local_coords.y, min_tm_y, max_tm_y, ts.tile_size.y, the_size.y - ts.tile_size.y)
		var remaped_center := Vector2(remaped_center_x, remaped_center_y)
		var rect = Rect2(remaped_center - (remaped_size * 0.5), remaped_size)
		draw_rect(rect, tile_color, true)
 
func on_editor_save_setup():
	tilemap_layer = Z_ResolveUtil.resolve_at(owner, Z_BasicTilemapLayer)
	compute_tm_boundaries()
	queue_redraw()

func on_editor_save_clear():
	pass

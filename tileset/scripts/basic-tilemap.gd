@tool
class_name Z_BasicTilemapLayer extends TileMapLayer

@export var test : String = ''

func on_editor_save_setup():
  tile_set = Gen_AllTileSets.TILESET_TILESET_BASIC_PLACEHOLDER_32X32_WITH_BORDERS

func on_editor_save_clear():
  print('clear')

const BITFLAGS = [ Vector2( 0, 0 ), 432, Vector2( 0, 1 ), 438, Vector2( 0, 2 ), 54, Vector2( 0, 3 ), 48, Vector2( 1, 0 ), 504, Vector2( 1, 1 ), 511, Vector2( 1, 2 ), 63, Vector2( 1, 3 ), 56, Vector2( 2, 0 ), 216, Vector2( 2, 1 ), 219, Vector2( 2, 2 ), 27, Vector2( 2, 3 ), 24, Vector2( 3, 0 ), 144, Vector2( 3, 1 ), 146, Vector2( 3, 2 ), 18, Vector2( 3, 3 ), 16, Vector2( 4, 0 ), 176, Vector2( 4, 1 ), 182, Vector2( 4, 2 ), 434, Vector2( 4, 3 ), 50, Vector2( 4, 4 ), 178, Vector2( 5, 0 ), 248, Vector2( 5, 1 ), 255, Vector2( 5, 2 ), 507, Vector2( 5, 3 ), 59, Vector2( 5, 4 ), 251, Vector2( 6, 0 ), 440, Vector2( 6, 1 ), 447, Vector2( 6, 2 ), 510, Vector2( 6, 3 ), 62, Vector2( 6, 4 ), 446, Vector2( 7, 0 ), 152, Vector2( 7, 1 ), 155, Vector2( 7, 2 ), 218, Vector2( 7, 3 ), 26, Vector2( 7, 4 ), 154, Vector2( 8, 0 ), 184, Vector2( 8, 1 ), 191, Vector2( 8, 2 ), 506, Vector2( 8, 3 ), 58, Vector2( 8, 4 ), 186, Vector2( 9, 0 ), 443, Vector2( 9, 1 ), 254, Vector2( 9, 2 ), 442, Vector2( 9, 3 ), 190, Vector2( 10, 2 ), 250, Vector2( 10, 3 ), 187 ]

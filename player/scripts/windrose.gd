@tool
class_name Z_PlayerWindrose extends Node2D

enum DIR { RIGHT, UP, LEFT, DOWN }

func _enter_tree() -> void:
  var vs := [Vector2.RIGHT, Vector2.UP, Vector2.LEFT, Vector2.DOWN]
  if Engine.is_editor_hint() and get_child_count() < 1:
    for dir in DIR.keys():
      var v:Vector2 = vs[DIR[dir]]
      var m := Marker2D.new()
      m.name = dir.to_pascal_case()
      m.position = v
      Z_Util.tool_add_child(self, m)

# func _draw() -> void:
#   draw_circle(right() * 32, 16, Color.RED)
#   draw_circle(left() * 32, 16, Color.RED)
#   draw_circle(down() * 32, 16, Color.RED)
#   draw_circle(up() * 32, 16, Color.RED)

func right() -> Vector2:
  return global_position.direction_to(get_child(DIR.RIGHT).global_position)
func up() -> Vector2:
  return global_position.direction_to(get_child(DIR.UP).global_position)
func left() -> Vector2:
  return global_position.direction_to(get_child(DIR.LEFT).global_position)
func down() -> Vector2:
  return global_position.direction_to(get_child(DIR.DOWN).global_position)

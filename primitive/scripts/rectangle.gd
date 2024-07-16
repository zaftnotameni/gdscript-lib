@tool
class_name Zaft_Primitive_Rectangle extends Node2D

@export var width : float = 32
@export var height : float = 32
## if centered, only width and height are used
@export var centered : bool = false
@export var color : Color = Color.HOT_PINK
@export var filled : bool = true
## if rect is given, width, height, centered, top, and left are all ignored
@export_group('optional')
@export_subgroup('rect')
@export var rect : Rect2 : get = get_rect
@export_subgroup('top/left')
@export var top : float = -16
@export var left : float = -16

func set_as_centered_rect():
  var half_width := width / 2;
  var half_height := height / 2;
  top = -half_height
  left = -half_width

func get_rect() -> Rect2:
  if rect: return rect
  else:
    if centered: set_as_centered_rect()
    return Rect2(left, top, width, height)

func _notification(what: int) -> void:
  if what == NOTIFICATION_EDITOR_PRE_SAVE:
    queue_redraw()

func _draw() -> void:
  draw_rect(rect, color, filled)

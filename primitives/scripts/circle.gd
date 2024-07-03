@tool
class_name Zaft_Primitive_Circle extends Node2D

@export var radius : float = 16.0
@export var center : Vector2 = Vector2.ZERO
@export var color : Color = Color.HOT_PINK
@export var filled : bool = true

func _notification(what: int) -> void:
  if what == NOTIFICATION_EDITOR_PRE_SAVE:
    queue_redraw()

func _draw() -> void:
  draw_circle(center, radius, color, filled)

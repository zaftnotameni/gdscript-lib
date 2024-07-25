class_name Z_Primitive_LineWithColliders extends Line2D

func _enter_tree() -> void:
  for i in (points.size() - 1):
    var bod := StaticBody2D.new()
    var col := CollisionShape2D.new()
    var seg = SegmentShape2D.new()
    seg.a = points[i]
    seg.b = points[i + 1]
    col.shape = seg
    bod.add_child(col)
    bod.collision_layer = 0
    bod.collision_mask = 0
    add_child(bod)
  if closed:
    var bod := StaticBody2D.new()
    var col := CollisionShape2D.new()
    var seg = SegmentShape2D.new()
    seg.a = points[-1]
    seg.b = points[0]
    col.shape = seg
    bod.add_child(col)
    add_child(bod)

class_name Z_ShaderLoader extends FlowContainer

func _enter_tree() -> void:
  for sm:ShaderMaterial in Gen_AllMaterials.new().ALL_MATERIALS:
    var cr := ColorRect.new()
    cr.name = sm.resource_path
    cr.material = sm
    cr.custom_minimum_size = Vector2(8,8)
    add_child.call_deferred(cr)

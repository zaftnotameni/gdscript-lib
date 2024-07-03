@tool
class_name Zaft_ReparentToLayer extends Node

@export var layer : Zaft_Autoload_Layers.LAYERS
@export var scene : PackedScene

var prop_defs : Dictionary
var prop_vals : Dictionary
var instance : Node

func _ready() -> void:
  if instance:
    print(instance)
    __zaft.layer.layer_named(layer).add_child(instance)
  else:
    instance = scene.instantiate()
    print(instance)
    for k in prop_vals.keys():
      print(k, prop_vals[k])
      instance.set(k, prop_vals[k])
    __zaft.layer.layer_named(layer).add_child(instance)

func from_editor_to_tool():
  if get_child_count() < 1:
    return
  if not instance:
    push_warning('instance must not be null')
  remove_child(instance)
  for prop in instance.get_property_list():
    if prop.usage == 6:
      prop_defs[prop.name] = prop
      prop_vals[prop.name] = instance.get(prop.name)

func from_tool_to_editor():
  if get_child_count() < 1:
    if instance:
      add_child(instance)
      instance.owner = owner if owner else self
    else:
      instance = scene.instantiate()
      add_child(instance)
      instance.owner = owner if owner else self

func set_tooled(val:bool):
  if _tooled != val:
    _tooled = val
    if val:
      from_editor_to_tool()
    else:
      from_tool_to_editor()

var _tooled := false
@export var tooled : bool : set = set_tooled, get = get_tooled
func get_tooled() -> bool: return _tooled

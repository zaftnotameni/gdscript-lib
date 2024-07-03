class_name Zaft_Layer_At_Node extends Node

@export var target_layer : Zaft_Autoload_Layers.LAYERS
@export var target_scene : PackedScene

func _ready() -> void:
  var layer := __zaft.layer.layer_named(target_layer) as Node
  var scene := target_scene.instantiate()
  layer.add_child(scene)

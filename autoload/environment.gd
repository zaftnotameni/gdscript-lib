class_name Z_Autoload_Environment extends Node

const ENVIRONMENT : Environment = preload('res://zaft/lib/resource/world-environment.tres')

@onready var world:WorldEnvironment=WorldEnvironment.new()

func _ready() -> void:
  world.environment = ENVIRONMENT
  world.name = "ZaWarudo"
  add_child(world)


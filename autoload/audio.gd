class_name Z_Autoload_Audio extends Node

@onready var director : Z_AudioDirector_Scene = preload('res://zaft/lib/audio/scenes/director.tscn').instantiate()

func _ready() -> void:
  director.name = "Director"
  add_child(director)

class_name Zaft_Autoload_Audio extends Node

@onready var director : Zaft_AudioDirector_Scene = preload('res://zaft/lib/audio/scenes/director.tscn').instantiate()

func _ready() -> void:
  director.name = "Director"
  add_child(director)

class_name Zaft_GameStateOnReady extends Node

@export var game_state : Zaft_Autoload_State.GAME_STATE

func _ready() -> void:
  Zaft_Autoload_State.game_state = game_state

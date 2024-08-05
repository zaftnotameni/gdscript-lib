class_name Z_GameStateOnReady extends Node

@export var game_state : Z_State.GAME_STATE

func _ready() -> void:
  Z_State.game_state = game_state

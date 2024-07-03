class_name Zaft_Movement_Stats_Resource extends Resource

@export var player_size := Vector2(16.0, 16.0)
@export var multiplier := 1.0

@export var facing := Vector2.RIGHT

@export var default : Zaft_Movement_Environment_Resource = Zaft_Movement_Environment_Resource.with(player_size,multiplier)
@export var grounded := default
@export var airborne := default
@export var underwater := default


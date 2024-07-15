class_name Zaft_PlayerStateMachine extends Zaft_StateMachine

func _enter_tree() -> void:
  add_to_group(Zaft_Autoload_Path.PLAYER_CHARACTER_STATE_MACHINE_GROUP)

func _ready() -> void:
  super()
  validate(Zaft_PlayerStateMachineState.STATE)

@export_group('custom-handlers')
## must be a script extending Zaft_PlayerStateInitial
@export var custom_initial : Script
## must be a script extending Zaft_PlayerStateIdling
@export var custom_idling : Script
## must be a script extending Zaft_PlayerStateStilling
@export var custom_stilling : Script
## must be a script extending Zaft_PlayerStateWalking
@export var custom_walking : Script
## must be a script extending Zaft_PlayerStateRunning
@export var custom_running : Script
## must be a script extending Zaft_PlayerStateMoving
@export var custom_moving : Script
## must be a script extending Zaft_PlayerStateJumping
@export var custom_jumping : Script
## must be a script extending Zaft_PlayerStateFalling
@export var custom_falling : Script
## must be a script extending Zaft_PlayerStateAscending
@export var custom_ascending : Script
## must be a script extending Zaft_PlayerStateDescending
@export var custom_descending : Script
## must be a script extending Zaft_PlayerStateDashing
@export var custom_dashing : Script
## must be a script extending Zaft_PlayerStateRolling
@export var custom_rolling : Script
## must be a script extending Zaft_PlayerStateDodging
@export var custom_dodging : Script


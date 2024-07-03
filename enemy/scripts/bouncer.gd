class_name Zaft_Bouncer extends Node

enum STATE { InitialFloorSnap = 0, Snapped, WallReached, CornerCase, TurnedCorner }

@export var state : STATE = STATE.InitialFloorSnap
@export var character : CharacterBody2D
@export var velocity : float = 16.0
@export var gravity_velocity : float = 16.0

func _ready() -> void:
  if not character:
    character = get_parent() as CharacterBody2D
  assert(character is CharacterBody2D, '%s must have a character' % get_path())

func initial_floor_snap():
  character.velocity = gravity_velocity * Vector2.DOWN.rotated(Vector2.UP.angle_to(character.up_direction))
  character.apply_floor_snap()
  character.move_and_slide()

func handle_wall_case():
  velocity = -velocity
  character.scale.x = -character.scale.x
  move_along()

func handle_corner_case():
  velocity = -velocity
  character.scale.x = -character.scale.x
  move_along()

func move_along():
  character.velocity = velocity * Vector2.RIGHT.rotated(Vector2.UP.angle_to(character.up_direction))
  character.move_and_slide()

func _physics_process(_delta: float) -> void:
  match state:
    STATE.InitialFloorSnap:
      initial_floor_snap()
      if character.is_on_floor():
        state = STATE.Snapped

    STATE.Snapped:
      move_along()
      if character.is_on_wall():
        state = STATE.WallReached
      elif not character.is_on_floor():
        state = STATE.CornerCase

    STATE.CornerCase:
      handle_corner_case()
      state = STATE.TurnedCorner

    STATE.TurnedCorner:
      move_along()
      if character.is_on_floor():
        state = STATE.Snapped
      else:
        move_along()

    STATE.WallReached:
      handle_wall_case()
      if not character.is_on_floor():
        state = STATE.InitialFloorSnap
      else:
        state = STATE.Snapped

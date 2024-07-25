class_name Z_Crawler extends Node

enum STATE { InitialFloorSnap = 0, Snapped, CornerCase, CornerTurned, WallReached }

@export var state : STATE = STATE.InitialFloorSnap
@export var character : CharacterBody2D
@export var velocity : float = 16.0
@export var gravity_velocity : float = 16.0
@export var corner_cast : RayCast2D
@export var floor_cast : RayCast2D

func _ready() -> void:
  if not character:
    character = get_parent() as CharacterBody2D
  assert(character is CharacterBody2D, '%s must have a character' % get_path())

func initial_floor_snap():
  character.velocity = gravity_velocity * Vector2.DOWN.rotated(Vector2.UP.angle_to(character.up_direction))
  character.move_and_slide()

func corner_case() -> bool:
  if not corner_cast or not floor_cast:
    return false
  return not corner_cast.is_colliding() and floor_cast.is_colliding()

func handle_wall_case():
  const wall_rotation = -PI/2.0
  character.rotate(wall_rotation)
  character.up_direction = character.up_direction.rotated(wall_rotation)
  character.apply_floor_snap()
  character.move_and_slide()

func handle_corner_case():
  const corner_rotation = PI/2.0
  character.rotate(corner_rotation)
  character.up_direction = character.up_direction.rotated(corner_rotation)
  character.apply_floor_snap()
  character.move_and_slide()

func move_along():
  character.velocity = velocity * Vector2.RIGHT.rotated(Vector2.UP.angle_to(character.up_direction))
  character.move_and_slide()

func _physics_process(_delta: float) -> void:
  match state:
    STATE.InitialFloorSnap:
      initial_floor_snap()
      if character.is_on_floor():
        state = STATE.Snapped

    STATE.CornerTurned:
      move_along()
      if not character.is_on_floor():
        state = STATE.InitialFloorSnap
      else:
        state = STATE.Snapped

    STATE.CornerCase:
      handle_corner_case()
      state = STATE.CornerTurned

    STATE.Snapped:
      move_along()
      if corner_case():
        state = STATE.CornerCase
      elif character.is_on_wall():
        state = STATE.WallReached

    STATE.WallReached:
      handle_wall_case()
      if not character.is_on_floor():
        state = STATE.InitialFloorSnap
      else:
        state = STATE.Snapped

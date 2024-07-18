class_name Zaft_PlayerGravityBasedOrientation extends Area2D

@onready var player : Zaft_PlayerCharacter = owner
@export var body : Zaft_PlayerBody
@export var windrose : Zaft_PlayerWindrose

var gravity_source : Zaft_GravityWell : get = get_closest_gravity_source
var gravity_sources : Array[Zaft_GravityWell] = []

func get_closest_gravity_source() -> Zaft_GravityWell:
  var s : Zaft_GravityWell = null
  for ss:Zaft_GravityWell in gravity_sources:
    if not s: s = ss; continue
    var d := s.global_position.distance_squared_to(global_position)
    var dd := ss.global_position.distance_squared_to(global_position)
    if dd < d: s = ss
  return s

func _ready() -> void:
  if not windrose: windrose = Zaft_ComponentBase.resolve_from(player, Zaft_PlayerWindrose)
  if not body: body = Zaft_ComponentBase.resolve_at(player, Zaft_PlayerBody)
  add_child(body.duplicate())

func _physics_process(_delta: float) -> void:
  on_gravity_source_updated()

func leave_gravity_source(new_gravity_source:Zaft_GravityWell):
  printt('leave', new_gravity_source)
  if gravity_sources.size() > 1:
    gravity_sources.erase(new_gravity_source)
  on_gravity_source_updated()

func enter_gravity_source(new_gravity_source:Zaft_GravityWell):
  printt('enter', new_gravity_source)
  if not gravity_sources.has(new_gravity_source): gravity_sources.push_back(new_gravity_source)
  # if gravity_source != new_gravity_source: gravity_sources.erase(new_gravity_source)
  on_gravity_source_updated()

func up_dir_on_floor(initial_up_dir:Vector2) -> Vector2:
  var raycast_params = PhysicsRayQueryParameters2D.new()
  raycast_params.from = global_position
  raycast_params.to = gravity_source.global_position
  var space_state = get_world_2d().direct_space_state
  var result = space_state.intersect_ray(raycast_params)
  if result and result.has('normal') and result.normal is Vector2:
    if result.normal.dot(initial_up_dir) > 0.8:
      return result.normal
  return initial_up_dir

func update_what_is_up(up_dir:Vector2):
  player.up_direction = up_dir
  player.rotation = Vector2.UP.angle_to(player.up_direction)

func on_gravity_source_updated():
  var initial_up_dir := -player.global_position.direction_to(gravity_source.global_position)
  var up_dir := up_dir_on_floor(initial_up_dir) # if player.is_on_floor() else initial_up_dir

  update_what_is_up(up_dir)


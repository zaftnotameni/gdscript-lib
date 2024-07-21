class_name Zaft_PlayerGravityBasedOrientation extends Area2D

@onready var player : Zaft_PlayerCharacter = owner
@export var body : Zaft_PlayerBody
@export var windrose : Zaft_PlayerWindrose

@onready var foot_cast_back : RayCast2D = %BackFootCast
@onready var foot_cast_front : RayCast2D = %FrontFootCast

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
  print_verbose('leave', new_gravity_source)
  if gravity_sources.size() > 1:
    gravity_sources.erase(new_gravity_source)
  on_gravity_source_updated()

func enter_gravity_source(new_gravity_source:Zaft_GravityWell):
  print_verbose('enter', new_gravity_source)
  if not new_gravity_source: return
  if not gravity_sources.has(new_gravity_source): gravity_sources.push_back(new_gravity_source)
  # if gravity_source != new_gravity_source: gravity_sources.erase(new_gravity_source)
  if not new_gravity_source.tree_exited.is_connected(on_grav_source_exit_tree):
    new_gravity_source.tree_exited.connect(on_grav_source_exit_tree)
  on_gravity_source_updated()

func on_grav_source_exit_tree():
  gravity_sources.clear()
  print_verbose('gravity-sources-before', gravity_sources)
  var closest := Zaft_GravityWell.resolve_closest(global_position)
  print_verbose('gravity-sources-after', closest)
  if closest: enter_gravity_source(closest)

func raycast_fire(from:Vector2=global_position, to:Vector2=gravity_source.global_position) -> Dictionary:
  var raycast_params := PhysicsRayQueryParameters2D.new()
  raycast_params.from = from
  raycast_params.to = to
  var space_state := get_world_2d().direct_space_state
  var result := space_state.intersect_ray(raycast_params)
  return result

func up_dir_on_floor(initial_up_dir:Vector2) -> Vector2:
  var center_res := raycast_fire()
  var center_is_hit := center_res and center_res.has('normal') and center_res.normal is Vector2
  if foot_cast_front.is_colliding() and not foot_cast_back.is_colliding():
    var result : Vector2 = foot_cast_front.get_collision_normal()
    if result.dot(initial_up_dir) > 0.9: return result
  if foot_cast_back.is_colliding() and not foot_cast_front.is_colliding():
    var result : Vector2 = foot_cast_front.get_collision_normal()
    if result.dot(initial_up_dir) > 0.9: return result
  if center_is_hit:
    var result : Vector2 = (center_res.normal).normalized()
    if result.dot(initial_up_dir) > 0.9: return result
  return initial_up_dir

func update_what_is_up(up_dir:Vector2):
  if up_dir.is_zero_approx(): return
  player.up_direction = up_dir
  player.rotation = Vector2.UP.angle_to(player.up_direction)

func on_gravity_source_updated():
  if not gravity_source: return
  var initial_up_dir := -player.global_position.direction_to(gravity_source.global_position)
  var up_dir := up_dir_on_floor(initial_up_dir) # if player.is_on_floor() else initial_up_dir
  update_what_is_up(up_dir)


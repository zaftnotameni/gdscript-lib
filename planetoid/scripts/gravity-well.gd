class_name Zaft_GravityWell extends Area2D

const DEFAULT_GRAVITY_STRENGTH : int = 512
const DEFAULT_GRAVITY_RADIUS : int = 512
const DEFAULT_ENTER_GRAVITY_METHOD_NAME := &'enter_gravity_source'
const DEFAULT_EXIT_GRAVITY_METHOD_NAME := &'leave_gravity_source'

## if a radius is set to a value > 0 and no shape is provided, a circle will be created automatically
@export var gravity_radius : int = DEFAULT_GRAVITY_RADIUS
@export var gravity_strength : int = DEFAULT_GRAVITY_STRENGTH
@export var linear_falloff: bool = false

@export var shape : CollisionShape2D

func on_body_entered(body:Node2D):
  if body and body.has_method(DEFAULT_ENTER_GRAVITY_METHOD_NAME):
    body.call(DEFAULT_ENTER_GRAVITY_METHOD_NAME, self)

func on_body_exited(body:Node2D):
  if body and body.has_method(DEFAULT_EXIT_GRAVITY_METHOD_NAME):
    body.call(DEFAULT_EXIT_GRAVITY_METHOD_NAME, self)

func create_default_shape() -> CollisionShape2D:
  shape = CollisionShape2D.new()
  shape.shape = CircleShape2D.new()
  (shape.shape as CircleShape2D).radius = gravity_radius
  add_child(shape)
  return shape

func _ready() -> void:
  body_entered.connect(on_body_entered)
  body_exited.connect(on_body_exited)
  if get_child_count() > 0 and get_child(0) is CollisionShape2D:
    if shape: push_warning('provided both a shape and a child shape, the child shape will be used, only provide one, at %s' % get_path())
    shape = get_child(0)
  if not shape: create_default_shape()

class_name Z_Gun extends Node2D

## point from which bullets will spawn
@export var muzzle : Node2D
## how many bullets to pre-allocate
@export var pool_size : int = 10
## which layer the bullets will be spawned at, ignored if given a pool already inside the tree
@export var pool_layer : Z_Layers.LAYERS
## the scene that will be spawned as a bullet
@export var bullet_scene : PackedScene
## method called on the bullet scene when a bullet is first created, the gun is passed as a parameter
@export var on_bullet_created := &'on_bullet_created'
## method called on the bullet scene when a bullet is taken from the pool, the gun is passed as a parameter
@export var on_take_from_pool := &'on_take_from_pool'
## method called on the bullet scene when a bullet is returned to the pool, the gun is passed as a parameter
@export var on_return_to_pool := &'on_return_to_pool'
## then node that will store the pooled bullets, a generic Node2D will be created automatically if not provided
@export var pool : Node2D
@export var warn_on_empty := false

var after_bullet_create_fn : Callable
var before_bullet_take_from_pool_fn : Callable

var pooled_bullets := []

func _ready() -> void:
  assert(bullet_scene, 'must provide a bullet scene %s' % get_path())
  assert(muzzle, 'must provide a muzzle %s' % get_path())
  if not pool:
    pool = Node2D.new()
    pool.name = 'ManagedBulletPool'
  for _i in pool_size:
    pool.add_child(return_to_pool(create_bullet('Bullet_%03d' % _i)))
  if not pool.is_inside_tree():
    assert(pool_layer != Z_Layers.LAYERS.invalid, 'must provide a valid layer %s' % get_path())
    __z.layer.layer_named(pool_layer).add_child(pool)

func _exit_tree() -> void:
  if pool:
    pool.queue_free()

func create_bullet(_name:='Bullet') -> Node2D:
  var b := bullet_scene.instantiate() as Node2D
  if not b: return
  b.name = _name
  if b.has_method(on_bullet_created):
    b.call(on_bullet_created, self)
  if after_bullet_create_fn:
    after_bullet_create_fn.call(b)
  return b

func next_from_pool(global_pos:=muzzle.global_position,_warn_on_empty:=warn_on_empty) -> Node2D:
  if not pool: return
  var b :Node2D = pooled_bullets.pop_back()
  if not b and _warn_on_empty: push_warning('%s ran out of bullets' % get_path())
  if not b: return
  Z_Util.node_turn_on(b)
  b.global_position = global_pos
  if before_bullet_take_from_pool_fn:
    before_bullet_take_from_pool_fn.call(b)
  if b.has_method(on_take_from_pool):
    b.call(on_take_from_pool, self)
  return b

func return_to_pool(b:Node2D) -> Node2D:
  if not b: return
  Z_Util.node_turn_off(b)
  pooled_bullets.push_back(b)
  if b.has_method(on_return_to_pool):
    b.call(on_return_to_pool, self)
  return b

func towards_muzzle() -> Vector2:
  return muzzle.global_position - global_position

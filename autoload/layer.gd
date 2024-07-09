class_name Zaft_Autoload_Layers extends Node

@onready var background:CanvasLayer=CanvasLayer.new()
@onready var level:CanvasLayer=CanvasLayer.new()
@onready var terrain:CanvasLayer=CanvasLayer.new()
@onready var platform:CanvasLayer=CanvasLayer.new()
@onready var interact:CanvasLayer=CanvasLayer.new()
@onready var player:CanvasLayer=CanvasLayer.new()
@onready var enemy:CanvasLayer=CanvasLayer.new()
@onready var player_bullet:CanvasLayer=CanvasLayer.new()
@onready var enemy_bullet:CanvasLayer=CanvasLayer.new()
@onready var pickup:CanvasLayer=CanvasLayer.new()
@onready var hud:CanvasLayer=CanvasLayer.new()
@onready var dialog:CanvasLayer=CanvasLayer.new()
@onready var popup:CanvasLayer=CanvasLayer.new()
@onready var menu:CanvasLayer=CanvasLayer.new()
@onready var overlay:CanvasLayer=CanvasLayer.new()
@onready var debug:CanvasLayer=CanvasLayer.new()
@onready var managed:Node2D=Node2D.new()

func wipe_all_managed(n:Node=managed,containers:=CHILDREN):
  for child_name:String in containers:
    var child := n.get_node(child_name.to_pascal_case()) as Node
    Zaft_Autoload_Util.children_wipe(child)

func _ready() -> void:
  add_managed_containers(managed)
  setup_layers_that_follow_the_viewport()
  setup_explicit_layer_order(managed)
  add_managed_node_to_current_scene(managed)
  notify_managed_layers_ready.call_deferred()

func notify_managed_layers_ready():
  __zaft.bus.sig_layer_managed_layers_ready.emit(managed)

func add_managed_containers(n:Node=managed,containers:=CHILDREN):
  for child_name:String in containers:
    var child := get(child_name) as Node
    child.name = child_name.to_pascal_case()
    n.add_child(child)

func setup_layers_that_follow_the_viewport(followers:=FOLLOW_VIEWPORT):
  for child_name:String in followers:
    set_follow_viewport(child_name, true)

func setup_explicit_layer_order(n:Node=managed):
  for idx:int in n.get_child_count():
    n.get_child(idx).set('layer', idx - 4)

func add_managed_node_to_current_scene(n:Node=managed):
  n.name = 'ZaftManaged'
  get_tree().current_scene.add_child(n)

func set_follow_viewport(_canvas:String,_follow:=true):
  get(_canvas).set('follow_viewport_enabled', _follow)

func layer_named(layer_name:LAYERS) -> Node:
  return get(LAYERS.find_key(layer_name))

enum LAYERS {
  invalid = 0,
  background,
  level,
  terrain,
  platform,
  interact,
  player,
  enemy,
  player_bullet,
  enemy_bullet,
  pickup,
  hud,
  dialog,
  popup,
  menu,
  overlay,
  debug
}

const CHILDREN : Array[String] = [
  'background',
  'level',
  'terrain',
  'platform',
  'interact',
  'player',
  'enemy',
  'player_bullet',
  'enemy_bullet',
  'pickup',
  'hud',
  'dialog',
  'popup',
  'menu',
  'overlay',
  'debug'
]

const FOLLOW_VIEWPORT : Array[String] = [
  'level',
  'terrain',
  'platform',
  'interact',
  'player',
  'enemy',
  'player_bullet',
  'enemy_bullet',
  'pickup',
  'popup'
]


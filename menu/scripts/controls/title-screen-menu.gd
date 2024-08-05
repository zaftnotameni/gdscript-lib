class_name Z_TitleScreen_Menu extends VBoxContainer

@export var scene_leaderboard : PackedScene
@export var scene_test : PackedScene
@export var scene_continue : PackedScene
@export var scene_load : PackedScene
@export var scene_start : PackedScene
@export var scene_options : PackedScene
@export var scene_about : PackedScene

@export var hide_leaderboard : bool
@export var hide_test : bool
@export var hide_continue : bool
@export var hide_load : bool
@export var hide_start : bool
@export var hide_options : bool
@export var hide_about : bool
@export var hide_exit : bool

@onready var btn_leaderboard := Z_TitleScreen_Button.new()
@onready var btn_test := Z_TitleScreen_Button.new()
@onready var btn_continue := Z_TitleScreen_Button.new()
@onready var btn_load := Z_TitleScreen_Button.new()
@onready var btn_start := Z_TitleScreen_Button.new()
@onready var btn_options := Z_TitleScreen_Button.new()
@onready var btn_about := Z_TitleScreen_Button.new()
@onready var btn_exit := Z_TitleScreen_Button.new()

@onready var btns = [
  btn_test,
  btn_continue,
  btn_load,
  btn_start,
  btn_leaderboard,
  btn_options,
  btn_about,
  btn_exit,
]

func on_button_pressed(btn_name:String,b:Button):
  var ps : PackedScene = get("scene_%s" % btn_name.to_snake_case())
  if ps:
    var s := ps.instantiate()
    s.tree_exited.connect(b.grab_focus, CONNECT_ONE_SHOT)
    s.process_mode = Node.ProcessMode.PROCESS_MODE_ALWAYS
    __z.layer.menu.add_child(s)
    var t := Z_Util.tween_fresh_eased_in_out_cubic()
    t.tween_property(s, ^'position:y', 0, 0.2).from(-1800)

func _ready() -> void:
  Z_State.title()
  btn_test.name = "Test"
  btn_continue.name = "Continue"
  btn_load.name = "Load"
  btn_start.name = "Start"
  btn_leaderboard.name = "Leaderboard"
  btn_options.name = "Options"
  btn_about.name = "About"
  btn_exit.name = "Exit"

  for b:Button in btns:
    b.text = b.name
    Z_Util.control_set_color(b,Color.WHITE)
    Z_Util.control_set_font_size(b, 32)
    Z_Util.control_set_minimum_x(b, 300.0)
    b.pressed.connect(on_button_pressed.bind(b.name, b))
    if get('hide_%s' % b.name.to_snake_case()):
      b.queue_free()
    if not get('hide_%s' % b.name.to_snake_case()):
      add_child(b)

  get_child(0).call_deferred("grab_focus")

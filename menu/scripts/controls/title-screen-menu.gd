class_name Zaft_TitleScreen_Menu extends VBoxContainer

@export var scene_test : PackedScene
@export var scene_continue : PackedScene
@export var scene_load : PackedScene
@export var scene_start : PackedScene
@export var scene_options : PackedScene
@export var scene_about : PackedScene

@export var hide_test : bool
@export var hide_continue : bool
@export var hide_load : bool
@export var hide_start : bool
@export var hide_options : bool
@export var hide_about : bool
@export var hide_exit : bool

@onready var btn_test := Zaft_TitleScreen_Button.new()
@onready var btn_continue := Zaft_TitleScreen_Button.new()
@onready var btn_load := Zaft_TitleScreen_Button.new()
@onready var btn_start := Zaft_TitleScreen_Button.new()
@onready var btn_options := Zaft_TitleScreen_Button.new()
@onready var btn_about := Zaft_TitleScreen_Button.new()
@onready var btn_exit := Zaft_TitleScreen_Button.new()

@onready var btns = [
  btn_test,
  btn_continue,
  btn_load,
  btn_start,
  btn_options,
  btn_about,
  btn_exit,
]

func on_button_pressed(btn_name:String,b:Button):
  var ps : PackedScene = get("scene_%s" % btn_name.to_snake_case())
  if ps:
    var s := ps.instantiate()
    s.tree_exited.connect(b.grab_focus, CONNECT_ONE_SHOT)
    __zaft.layer.menu.add_child(s)
    var t := Zaft_Autoload_Util.tween_fresh_eased_in_out_cubic()
    t.tween_property(s, ^'position:y', 0, 0.2).from(-1800)

func _ready() -> void:
  Zaft_Autoload_State.title()
  btn_test.name = "Test"
  btn_continue.name = "Continue"
  btn_load.name = "Load"
  btn_start.name = "Start"
  btn_options.name = "Options"
  btn_about.name = "About"
  btn_exit.name = "Exit"

  for b:Button in btns:
    b.text = b.name
    Zaft_Autoload_Util.control_set_color(b,Color.WHITE)
    Zaft_Autoload_Util.control_set_font_size(b, 32)
    Zaft_Autoload_Util.control_set_minimum_x(b, 300.0)
    b.pressed.connect(on_button_pressed.bind(b.name, b))
    if get('hide_%s' % b.name.to_snake_case()):
      b.queue_free()
    if not get('hide_%s' % b.name.to_snake_case()):
      add_child(b)

  get_child(0).call_deferred("grab_focus")

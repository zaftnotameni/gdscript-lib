class_name Zaft_TitleScreen_Menu extends VBoxContainer

@export var scene_test : PackedScene
@export var scene_continue : PackedScene
@export var scene_load : PackedScene
@export var scene_start : PackedScene
@export var scene_options : PackedScene
@export var scene_about : PackedScene

@export var show_test : bool
@export var show_continue : bool
@export var show_load : bool
@export var show_start : bool
@export var show_options : bool
@export var show_about : bool
@export var show_exit : bool

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

func on_button_pressed(btn_name:String):
  var ps : PackedScene = get("scene_%s" % btn_name.to_snake_case())
  if ps:
    __zaft.layer.menu.add_child(ps.instantiate())

func _ready() -> void:
  btn_test.name = "Test"
  btn_continue.name = "Continue"
  btn_load.name = "Load"
  btn_start.name = "Start"
  btn_options.name = "Options"
  btn_about.name = "About"
  btn_exit.name = "Exit"

  for b:Button in btns:
    b.text = b.name
    __zaft.util.for_control.set_color(b,Color.WHITE)
    __zaft.util.for_control.set_font_size(b, 32)
    __zaft.util.for_control.set_minimum_x(b, 300.0)
    b.pressed.connect(on_button_pressed.bind(b.name))
    add_child(b)

  get_child(0).call_deferred("grab_focus")

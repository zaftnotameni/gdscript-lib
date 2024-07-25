class_name Z_AudioSliders_Node extends VBoxContainer

@onready var slider_master := Z_AudioSlider_Node.for_master()
@onready var slider_bgm := Z_AudioSlider_Node.for_bgm()
@onready var slider_sfx := Z_AudioSlider_Node.for_sfx()
@onready var slider_ui := Z_AudioSlider_Node.for_ui()

func _ready() -> void:
  add_child(slider_master)
  add_spacer(false)
  add_child(slider_bgm)
  add_spacer(false)
  add_child(slider_sfx)
  add_spacer(false)
  add_child(slider_ui)
  call_deferred('set_focus_to_master')

var previous_focus : Control

func _exit_tree() -> void:
  if previous_focus:
    previous_focus.grab_focus()

func set_focus_to_master():
  previous_focus = get_viewport().gui_get_focus_owner()
  slider_master.slider.call_deferred("grab_focus")

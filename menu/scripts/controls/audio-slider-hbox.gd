class_name Z_AudioSlider_Node extends HBoxContainer

@export var bus : BUS = BUS.Master

enum BUS { Master = 0, BGM, SFX, UI }

@onready var lbl_name := Label.new()
@onready var lbl_value := Label.new()
@onready var slider := HSlider.new()

func get_volume_as_linear() -> int:
  return volume_getters[bus].call()

func update_value_from_bus():
  lbl_value.text = str(get_volume_as_linear())

func update_slider_from_bus():
  slider.value = get_volume_as_linear()

func on_slider_value_changed(new_value:int):
  volume_signals[bus].emit(new_value,lbl_value)
  call_deferred('update_slider_from_bus')
  volume_testers[bus].call()

func _ready() -> void:
  size_flags_horizontal = SIZE_SHRINK_CENTER
  setup_slider()
  setup_name()
  setup_value()
  add_child(lbl_name)
  add_spacer(false)
  add_child(slider)
  add_spacer(false)
  add_child(lbl_value)

func setup_label(lbl:Label):
  lbl.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
  lbl.grow_horizontal = GROW_DIRECTION_BOTH
  lbl.size_flags_horizontal = SIZE_FILL
  lbl.grow_vertical = GROW_DIRECTION_BOTH
  lbl.size_flags_vertical = SIZE_FILL
  lbl.custom_minimum_size.x = 150
  Z_Util.control_set_font_size(lbl,32)

func setup_name():
  setup_label(lbl_name)
  lbl_name.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
  lbl_name.name = "Name"
  lbl_name.text = volume_names[bus]

func setup_value():
  setup_label(lbl_value)
  lbl_value.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
  lbl_value.name = "ValueFromBus"
  update_value_from_bus()

func setup_slider():
  slider.custom_minimum_size.x = 300
  slider.grow_horizontal = slider.GROW_DIRECTION_BOTH
  slider.size_flags_horizontal = slider.SIZE_EXPAND_FILL
  slider.grow_vertical = slider.GROW_DIRECTION_BOTH
  slider.size_flags_vertical = Control.SIZE_EXPAND_FILL
  slider.value_changed.connect(on_slider_value_changed)
  slider.name = "Value"
  slider.rounded = true
  update_slider_from_bus()
  slider.focus_entered.connect(__z.bus.sig_control_slider_focus_enter.emit.bind(slider))
  slider.mouse_entered.connect(__z.bus.sig_control_slider_mouse_enter.emit.bind(slider))
  slider.mouse_exited.connect(__z.bus.sig_control_slider_mouse_exit.emit.bind(slider))

@onready var volume_names = {
  BUS.Master: "Master",
  BUS.BGM: "BGM",
  BUS.SFX: "SFX",
  BUS.UI: "UI",
}

@onready var volume_signals = {
  BUS.Master: __z.bus.sig_audio_master_volume_changed,
  BUS.BGM: __z.bus.sig_audio_bgm_volume_changed,
  BUS.SFX: __z.bus.sig_audio_sfx_volume_changed,
  BUS.UI: __z.bus.sig_audio_ui_volume_changed,
}

@onready var volume_getters = {
  BUS.Master: __z.audio.director.get_volume_master,
  BUS.BGM: __z.audio.director.get_volume_bgm,
  BUS.SFX: __z.audio.director.get_volume_sfx,
  BUS.UI: __z.audio.director.get_volume_ui,
}

@onready var volume_testers = {
  BUS.Master: __z.audio.director.play_test_master,
  BUS.BGM: __z.audio.director.play_test_bgm,
  BUS.SFX: __z.audio.director.play_test_sfx,
  BUS.UI: __z.audio.director.play_test_ui,
}

static func for_master() -> Z_AudioSlider_Node:
  return for_bus(BUS.Master)

static func for_bgm() -> Z_AudioSlider_Node:
  return for_bus(BUS.BGM)

static func for_sfx() -> Z_AudioSlider_Node:
  return for_bus(BUS.SFX)

static func for_ui() -> Z_AudioSlider_Node:
  return for_bus(BUS.UI)

static func for_bus(b:BUS) -> Z_AudioSlider_Node:
  var x := Z_AudioSlider_Node.new()
  x.bus = b
  x.name = BUS.find_key(b)
  return x


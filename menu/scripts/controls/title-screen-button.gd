class_name Zaft_TitleScreen_Button extends Button

@onready var bus_pressed_signal_name := "sig_title_%s_pressed" % name.to_lower()

func _ready() -> void:
  pressed.connect(__zaft.bus.emit_signal.bind(bus_pressed_signal_name))
  focus_entered.connect(__zaft.bus.sig_control_button_focus_enter.emit.bind(self))
  mouse_entered.connect(__zaft.bus.sig_control_button_mouse_enter.emit.bind(self))
  mouse_exited.connect(__zaft.bus.sig_control_button_mouse_exit.emit.bind(self))
  button_up.connect(__zaft.bus.sig_control_button_down.emit.bind(self))
  button_down.connect(__zaft.bus.sig_control_button_up.emit.bind(self))

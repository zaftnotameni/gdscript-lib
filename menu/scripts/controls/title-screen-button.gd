class_name Z_TitleScreen_Button extends Button

@onready var bus_pressed_signal_name := "sig_title_%s_pressed" % name.to_snake_case().to_lower()

var psoe : Z_PlaySoundOnEvent
var sound : AudioStreamPlayer

func _enter_tree() -> void:
  psoe = Z_PlaySoundOnEvent.new()
  psoe.should_play_on_mouse_enter = true
  psoe.should_play_on_mouse_exit = false
  psoe.should_play_on_focus_enter = true
  psoe.should_play_on_focus_exit = false
  psoe.should_play_on_pressed = true
  sound = AudioStreamPlayer.new()
  sound.bus = Z_AudioDirector_Scene.BUS_NAME_UI
  sound.stream = Gen_AllAudio.AUDIO_TOGGLE001
  psoe.add_child(sound)
  add_child.call_deferred(psoe)

func _ready() -> void:
  pressed.connect(__z.bus.emit_signal.bind(bus_pressed_signal_name))
  focus_entered.connect(__z.bus.sig_control_button_focus_enter.emit.bind(self))
  mouse_entered.connect(__z.bus.sig_control_button_mouse_enter.emit.bind(self))
  mouse_exited.connect(__z.bus.sig_control_button_mouse_exit.emit.bind(self))
  button_up.connect(__z.bus.sig_control_button_down.emit.bind(self))
  button_down.connect(__z.bus.sig_control_button_up.emit.bind(self))

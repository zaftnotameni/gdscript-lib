class_name Zaft_Autoload_Bus extends Node

class Layer:
  signal managed_layers_ready(managed_layers_node:Zaft_ManagedLayers_Node)
var layer := Layer.new()

class Audio:
  signal master_volume_changed(volume:int,ui:Label)
  signal bgm_volume_changed(volume:int,ui:Label)
  signal sfx_volume_changed(volume:int,ui:Label)
  signal ui_volume_changed(volume:int,ui:Label)
var audio := Audio.new()

class TitleScreen:
  signal continue_pressed()
  signal start_pressed()
  signal load_pressed()
  signal test_pressed()
  signal options_pressed()
  signal about_pressed()
  signal exit_pressed()

  signal slider_focus_enter(slider:Slider)
  signal slider_mouse_enter(slider:Slider)
  signal slider_mouse_exit(slider:Slider)
  signal button_focus_enter(btn:Button)
  signal button_mouse_enter(btn:Button)
  signal button_mouse_exit(btn:Button)
  signal button_down(btn:Button)
  signal button_up(btn:Button)
var title_screen := TitleScreen.new()

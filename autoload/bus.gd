class_name Zaft_Autoload_Bus extends Node

signal sig_camera_constant_trauma_request(amount:float)
signal sig_camera_constant_trauma_relief(amount:float)
signal sig_camera_constant_trauma_clear()
signal sig_camera_trauma_request(amount:float,max:float)
signal sig_camera_trauma_relief(amount:float)
signal sig_camera_trauma_clear()

signal sig_layer_managed_layers_ready(managed_layers_node:CanvasItem)

signal sig_audio_master_volume_changed(volume:int,ui:Label)
signal sig_audio_bgm_volume_changed(volume:int,ui:Label)
signal sig_audio_sfx_volume_changed(volume:int,ui:Label)
signal sig_audio_ui_volume_changed(volume:int,ui:Label)

signal sig_title_continue_pressed()
signal sig_title_start_pressed()
signal sig_title_load_pressed()
signal sig_title_test_pressed()
signal sig_title_options_pressed()
signal sig_title_about_pressed()
signal sig_title_exit_pressed()

signal sig_control_slider_focus_enter(slider:Slider)
signal sig_control_slider_mouse_enter(slider:Slider)
signal sig_control_slider_mouse_exit(slider:Slider)
signal sig_control_button_focus_enter(btn:Button)
signal sig_control_button_mouse_enter(btn:Button)
signal sig_control_button_mouse_exit(btn:Button)
signal sig_control_button_down(btn:Button)
signal sig_control_button_up(btn:Button)

class_name Z_Bus extends Node

signal sig_global_player_set(new_player:Node2D,prev_player:Node2D)
signal sig_global_camera_set(new_cam:Camera2D,prev_cam:Camera2D)
signal sig_global_level_set(new_level:Node2D,prev_level:Node2D)
signal sig_global_menu_set(new_menu:Control,prev_menu:Control)

signal sig_game_state_changed(next:Z_State.GAME_STATE,prev:Z_State.GAME_STATE)
signal sig_pause_requested()
signal sig_unpause_requested()
signal sig_quit_to_title_requested()

signal sig_layer_managed_layers_ready(managed_layers_node:CanvasItem)

signal sig_audio_master_volume_changed(volume:int,ui:Label)
signal sig_audio_bgm_volume_changed(volume:int,ui:Label)
signal sig_audio_sfx_volume_changed(volume:int,ui:Label)
signal sig_audio_ui_volume_changed(volume:int,ui:Label)

signal sig_control_slider_focus_enter(slider:Slider)
signal sig_control_slider_mouse_enter(slider:Slider)
signal sig_control_slider_mouse_exit(slider:Slider)
signal sig_control_button_focus_enter(btn:Button)
signal sig_control_button_mouse_enter(btn:Button)
signal sig_control_button_mouse_exit(btn:Button)
signal sig_control_button_down(btn:Button)
signal sig_control_button_up(btn:Button)

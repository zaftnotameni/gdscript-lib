class_name Z_AudioDirectorScene extends Node

const VOLUME_PREFERENCES_FILENAME = "user://volume-preferences.tres"
@export var volume_preferences : Z_VolumePreferencesResource

@onready var streams_master : Node = $Streams/Master
@onready var streams_bgm : Node = $Streams/BGM
@onready var streams_sfx : Node = $Streams/SFX
@onready var streams_ui : Node = $Streams/UI

@onready var test_sound_master : AudioStreamPlayer = $Streams/Master/Test
@onready var test_sound_bgm : AudioStreamPlayer = $Streams/BGM/Test
@onready var test_sound_sfx : AudioStreamPlayer = $Streams/SFX/Test
@onready var test_sound_ui : AudioStreamPlayer = $Streams/UI/Test

@onready var sfx_die : AudioStreamPlayer = $Streams/SFX/Die
@onready var sfx_respawn_active : AudioStreamPlayer = $Streams/SFX/RespawnActive

@onready var bgm_title_screen: AudioStreamPlayer = $Streams/BGM/TitleScreen
@onready var bgm_level: AudioStreamPlayer = $Streams/BGM/Level
@onready var bgm_ending: AudioStreamPlayer = $Streams/BGM/Ending

@onready var ui_button_focus_in : AudioStreamPlayer = $Streams/UI/ButtonFocusIn
@onready var ui_button_focus_out : AudioStreamPlayer = $Streams/UI/ButtonFocusOut
@onready var ui_button_mouse_in : AudioStreamPlayer = $Streams/UI/ButtonMouseIn
@onready var ui_button_mouse_out : AudioStreamPlayer = $Streams/UI/ButtonMouseOut
@onready var ui_button_click : AudioStreamPlayer = $Streams/UI/ButtonClick

@onready var exclusive_bgm = [bgm_title_screen, bgm_level, bgm_ending]

const BUS_NAME_MASTER := "Master"
const BUS_NAME_BGM := "BGM"
const BUS_NAME_SFX := "SFX"
const BUS_NAME_UI := "UI"

@onready var bus_index_master := AudioServer.get_bus_index("Master")
@onready var bus_index_bgm := AudioServer.get_bus_index("BGM")
@onready var bus_index_sfx := AudioServer.get_bus_index("SFX")
@onready var bus_index_ui := AudioServer.get_bus_index("UI")

@onready var save_timer := Timer.new()

const LAYOUT : AudioBusLayout = preload('res://zaft/lib/audio/resources/default_bus_layout.tres')

func _enter_tree() -> void:
	process_mode = ProcessMode.PROCESS_MODE_ALWAYS
	AudioServer.set_bus_layout(LAYOUT)

func set_loop(player:AudioStreamPlayer):
	player.finished.connect(player.play)

func _ready() -> void:
	assert(bus_index_master >= 0, "Master bus missing")
	assert(bus_index_bgm >= 0, "BGM bus missing")
	assert(bus_index_sfx >= 0, "SFX bus missing")
	assert(bus_index_ui >= 0, "UI bus missing")
	set_initial_volume()
	connect_to_bus()
	ensure_streams_in_each_container_use_the_correct_audio_bus()
	setup_save_timer()

func setup_save_timer():
	save_timer.wait_time = 1.0
	save_timer.one_shot = true
	save_timer.autostart = false
	save_timer.timeout.connect(save_current_volume_preferences_debounced)
	add_child(save_timer)

func ensure_streams_in_each_container_use_the_correct_audio_bus():
	for c:AudioStreamPlayer in streams_master.get_children(): c.bus = "Master"
	for c:AudioStreamPlayer in streams_bgm.get_children(): c.bus = "BGM"
	for c:AudioStreamPlayer in streams_sfx.get_children(): c.bus = "SFX"
	for c:AudioStreamPlayer in streams_ui.get_children(): c.bus = "UI"

func play_ranged(player: AudioStreamPlayer, _range:float=0.05):
	play_pitched(player, 1.0 + randf_range(-_range, _range))

func play_named_ui(_name:String, pitch_scale: float = 1.0):
	play_pitched(streams_ui.get_node(_name), pitch_scale)

func play_named_sfx(_name:String, pitch_scale: float = 1.0):
	play_pitched(streams_sfx.get_node(_name), pitch_scale)

func play_named_bgm(_name:String, pitch_scale: float = 1.0):
	play_pitched(streams_bgm.get_node(_name), pitch_scale)

func play_test_master():
	play_pitched(test_sound_master)

func play_test_bgm():
	play_pitched(test_sound_bgm)

func play_test_sfx():
	play_pitched(test_sound_sfx)

func play_test_ui():
	play_pitched(test_sound_ui)

func play_pitched_2d(player: AudioStreamPlayer2D, pitch_scale: float = 1.0, only_if_not_playing:= false, loop := false):
	if only_if_not_playing:
		if player.playing: return
	if OS.has_feature('web'):
		player.playback_type = AudioServer.PlaybackType.PLAYBACK_TYPE_SAMPLE
		if not player.tree_exiting.is_connected(player.stop):
			player.tree_exiting.connect(player.stop, CONNECT_ONE_SHOT)
	if loop:
		player.finished.connect(play_pitched.bind(player, pitch_scale, only_if_not_playing, loop), CONNECT_ONE_SHOT)
	player.pitch_scale = pitch_scale
	player.play()

func play_pitched_force_stream_2d(player: AudioStreamPlayer2D, pitch_scale: float = 1.0, only_if_not_playing := false, loop := false):
	player.playback_type = AudioServer.PlaybackType.PLAYBACK_TYPE_STREAM
	if only_if_not_playing:
		if player.playing: return
	if loop:
		player.finished.connect(play_pitched.bind(player, pitch_scale, only_if_not_playing, loop), CONNECT_ONE_SHOT)
	player.pitch_scale = pitch_scale
	player.play()

func play_force_stream_bgm_level(): play_force_stream_bgm(bgm_level)
func play_force_stream_bgm_title_screen(): play_force_stream_bgm(bgm_title_screen)
func play_force_stream_bgm_ending(): play_force_stream_bgm(bgm_ending)
func play_force_stream_bgm(player: AudioStreamPlayer):
	for p:AudioStreamPlayer in exclusive_bgm:
		if p != player:
			p.stream_paused = true
			p.stop()
			p.playing = false
			p.process_mode = Node.PROCESS_MODE_DISABLED
	if player.playing: return
	player.process_mode = Node.PROCESS_MODE_ALWAYS
	player.playback_type = AudioServer.PlaybackType.PLAYBACK_TYPE_STREAM
	match player:
		bgm_title_screen:
			if not player.finished.is_connected(play_force_stream_bgm_title_screen):
				player.finished.connect(play_force_stream_bgm_title_screen, CONNECT_ONE_SHOT)
		bgm_level:
			if not player.finished.is_connected(play_force_stream_bgm_level):
				player.finished.connect(play_force_stream_bgm_level, CONNECT_ONE_SHOT)
		bgm_ending:
			if not player.finished.is_connected(play_force_stream_bgm_ending):
				player.finished.connect(play_force_stream_bgm_ending, CONNECT_ONE_SHOT)
	player.pitch_scale = 1.0
	player.stream_paused = false
	player.play()

func play_pitched_no_hax(player: AudioStreamPlayer, pitch_scale: float = 1.0, only_if_not_playing := false, loop := false):
	if only_if_not_playing:
		if player.playing: return
	if loop:
		player.finished.connect(play_pitched.bind(player, pitch_scale, only_if_not_playing, loop), CONNECT_ONE_SHOT)
	player.pitch_scale = pitch_scale
	player.play()

func play_pitched(player: AudioStreamPlayer, pitch_scale: float = 1.0, only_if_not_playing := false, loop := false):
	if only_if_not_playing:
		if player.playing: return
	if OS.has_feature('web'):
		player.playback_type = AudioServer.PlaybackType.PLAYBACK_TYPE_SAMPLE
		if not player.tree_exiting.is_connected(player.stop):
			player.tree_exiting.connect(player.stop, CONNECT_ONE_SHOT)
	if loop:
		player.finished.connect(play_pitched.bind(player, pitch_scale, only_if_not_playing, loop), CONNECT_ONE_SHOT)
	player.pitch_scale = pitch_scale
	player.play()

func get_volume_sfx() -> int:
	return get_volume_linear(bus_index_sfx)

func get_volume_bgm() -> int:
	return get_volume_linear(bus_index_bgm)

func get_volume_ui() -> int:
	return get_volume_linear(bus_index_ui)

func get_volume_master() -> int:
	return get_volume_linear(bus_index_master)

func on_ui_volume_changed(v:int,ui:Label=null):
	on_bus_volume_changed(bus_index_ui,v,ui)

func on_sfx_volume_changed(v:int,ui:Label=null):
	on_bus_volume_changed(bus_index_sfx,v,ui)

func on_bgm_volume_changed(v:int,ui:Label=null):
	on_bus_volume_changed(bus_index_bgm,v,ui)

func on_master_volume_changed(v:int,ui:Label=null):
	on_bus_volume_changed(bus_index_master,v,ui)

func on_bus_volume_changed(idx:int,v:int,ui:Label=null):
	set_volume_linear(idx,v)
	if ui != null: ui.text = "%s" % v
	match idx:
		bus_index_master: volume_preferences.master = v
		bus_index_bgm: volume_preferences.bgm = v
		bus_index_sfx: volume_preferences.sfx = v
		bus_index_ui: volume_preferences.ui = v
	save_current_volume_preferences()

func save_current_volume_preferences():
	save_timer.stop()
	save_timer.start(1.0)

func save_current_volume_preferences_debounced():
	ResourceSaver.save(volume_preferences, VOLUME_PREFERENCES_FILENAME)

func get_volume_linear(idx:int) -> int:
	assert(idx >= 0, 'audio bus index must be >= 0')
	assert(AudioServer.get_bus_name(idx), 'audio bus must exist')
	return roundi(100.0 * db_to_linear(AudioServer.get_bus_volume_db(idx)))

func set_volume_linear(idx:int,vol_lin:int):
	assert(idx >= 0, 'audio bus index must be >= 0')
	assert(AudioServer.get_bus_name(idx), 'audio bus must exist')
	AudioServer.set_bus_volume_db(idx, linear_to_db(vol_lin / 100.0))

func set_initial_volume():
	if ResourceLoader.exists(VOLUME_PREFERENCES_FILENAME):
		set_initial_volume_from(ResourceLoader.load(VOLUME_PREFERENCES_FILENAME))
	else:
		set_initial_volume_from(Z_VolumePreferencesResource.new())

func set_initial_volume_from(prefs:=Z_VolumePreferencesResource.new()):
	volume_preferences = prefs
	set_volume_linear(bus_index_master,prefs.master)
	set_volume_linear(bus_index_bgm,prefs.bgm)
	set_volume_linear(bus_index_sfx,prefs.sfx)
	set_volume_linear(bus_index_ui,prefs.ui)

func connect_to_bus():
	__z.bus.sig_audio_ui_volume_changed.connect(on_ui_volume_changed)
	__z.bus.sig_audio_sfx_volume_changed.connect(on_sfx_volume_changed)
	__z.bus.sig_audio_bgm_volume_changed.connect(on_bgm_volume_changed)
	__z.bus.sig_audio_master_volume_changed.connect(on_master_volume_changed)


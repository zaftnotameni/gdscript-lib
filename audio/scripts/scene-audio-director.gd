class_name Zaft_AudioDirector_Scene extends Node

const VOLUME_PREFERENCES_FILENAME = "user://volume-preferences1.tres"
@export var volume_preferences : Zaft_VolumePreferences_Resource

@onready var streams_master : Node = $Streams/Master
@onready var streams_bgm : Node = $Streams/BGM
@onready var streams_sfx : Node = $Streams/SFX
@onready var streams_ui : Node = $Streams/UI

@onready var test_sound_master : Node = $Streams/Master/Test
@onready var test_sound_bgm : Node = $Streams/BGM/Test
@onready var test_sound_sfx : Node = $Streams/SFX/Test
@onready var test_sound_ui : Node = $Streams/UI/Test

@onready var bus_index_master := AudioServer.get_bus_index("Master")
@onready var bus_index_bgm := AudioServer.get_bus_index("BGM")
@onready var bus_index_sfx := AudioServer.get_bus_index("SFX")
@onready var bus_index_ui := AudioServer.get_bus_index("UI")

@onready var save_timer := Timer.new()

const LAYOUT : AudioBusLayout = preload('res://default_bus_layout.tres')

func _enter_tree() -> void:
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

func play_pitched(player: AudioStreamPlayer, pitch_scale: float = 1.0):
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
    set_initial_volume_from(Zaft_VolumePreferences_Resource.new())

func set_initial_volume_from(prefs:=Zaft_VolumePreferences_Resource.new()):
  volume_preferences = prefs
  set_volume_linear(bus_index_master,prefs.master)
  set_volume_linear(bus_index_bgm,prefs.bgm)
  set_volume_linear(bus_index_sfx,prefs.sfx)
  set_volume_linear(bus_index_ui,prefs.ui)

func connect_to_bus():
  __zaft.bus.audio.ui_volume_changed.connect(on_ui_volume_changed)
  __zaft.bus.audio.sfx_volume_changed.connect(on_sfx_volume_changed)
  __zaft.bus.audio.bgm_volume_changed.connect(on_bgm_volume_changed)
  __zaft.bus.audio.master_volume_changed.connect(on_master_volume_changed)


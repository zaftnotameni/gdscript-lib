class_name Z_Closer_Button extends Button

@export var target : Node

const TARGET_GROUPS = [
  "popup",
  "sub-menu",
  "closeable",
]

const TARGET_ACTIONS = [
  "menu-close",
  "menu-back",
]

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
  text = "Close"
  process_mode = ProcessMode.PROCESS_MODE_ALWAYS
  Z_Autoload_Util.control_set_font_size(self, 32)
  if not target: target = find_closeable_parent()
  pressed.connect(close_target)

func close_target():
  if target and not target.is_queued_for_deletion():
    var t := Z_Autoload_Util.tween_fresh_eased_in_out_cubic()
    t.set_pause_mode(Tween.TweenPauseMode.TWEEN_PAUSE_PROCESS)
    t.tween_property(target, ^'position:y', -1800, 0.2).from(0)
    t.tween_callback(target.queue_free)

func _input(event: InputEvent) -> void:
  if TARGET_ACTIONS.any(event.is_action_pressed):
    get_viewport().set_input_as_handled()
    close_target()

func find_closeable_parent(n:Node=self) -> Node:
  if TARGET_GROUPS.any(n.is_in_group): return n
  if n == get_tree().current_scene:
    printerr("could not find any parent member of ", TARGET_GROUPS)
    return null
  if not n.get_parent():
    printerr("could not find any parent member of ", TARGET_GROUPS)
    return null
  return find_closeable_parent(n.get_parent())

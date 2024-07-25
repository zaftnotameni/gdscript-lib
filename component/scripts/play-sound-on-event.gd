class_name Z_PlaySoundOnEvent extends Node

@export var should_play_on_mouse_enter := false
@export var should_play_on_mouse_exit := false
@export var should_play_on_focus_enter := false
@export var should_play_on_focus_exit := false
@export var should_play_on_pressed := false

var ctrl : Control
var btn : Button
var sound : AudioStreamPlayer

func play_sound():
  if is_inside_tree():
    sound.play()

func _ready() -> void:
  if get_child_count() <= 0:
    push_error('first child must be an audiostreamplayer at %s' % get_path())
  ctrl = get_parent() as Control
  btn = get_parent() as Button
  sound = get_child(0) as AudioStreamPlayer
  if not sound:
    push_error('first child must be an audiostreamplayer at %s' % get_path())
  if not ctrl:
    push_error('parent must be a control at %s' % get_path())
  if should_play_on_pressed:
    if not btn:
      push_error('parent must be a button at %s' % get_path())
    btn.pressed.connect(play_sound)
  if should_play_on_mouse_enter:
    ctrl.mouse_entered.connect(play_sound)
  if should_play_on_mouse_exit:
    ctrl.mouse_exited.connect(play_sound)
  if should_play_on_focus_enter:
    ctrl.focus_entered.connect(play_sound)
  if should_play_on_focus_exit:
    ctrl.focus_exited.connect(play_sound)


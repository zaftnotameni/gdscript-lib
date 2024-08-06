class_name Z_PlaySoundOnEvent extends Node

## name of the sound in the audio director
@export var named : StringName
@export var plays_on_mouse_enter := false
@export var plays_on_mouse_exit := false
@export var plays_on_focus_enter := false
@export var plays_on_focus_exit := false
@export var plays_on_pressed := false

var ctrl : Control
var btn : Button
var sound : AudioStreamPlayer
var is_named : bool

func play_sound():
	if not is_named and is_inside_tree():
		sound.play()
	if is_named:
		named_sound().play()

func named_sound():
	sound = __z.audio.get(named)
	return sound

func resolve_sound():
	if not sound and named and not named.is_empty():
		if not named in __z.audio:
			push_error('invalid named sound %s must be an audiostreamplayer at the audio director, %s' % [named, get_path()])
			return
		else:
			is_named = true
			return
	if not sound and get_child_count() <= 0:
		push_error('first child must be an audiostreamplayer at %s' % get_path())
	if not sound:
		sound = get_child(0) as AudioStreamPlayer

func _ready() -> void:
	ctrl = get_parent() as Control
	btn = get_parent() as Button
	resolve_sound()
	if not sound and not is_named:
		push_error('first child must be an audiostreamplayer at %s' % get_path())
	if not ctrl:
		push_error('parent must be a control at %s' % get_path())
	if plays_on_pressed:
		if not btn:
			push_error('parent must be a button at %s' % get_path())

	if btn: btn.pressed.connect(on_pressed)
	if ctrl: ctrl.mouse_entered.connect(on_mouse_entered)
	if ctrl: ctrl.mouse_exited.connect(on_mouse_exited)
	if ctrl: ctrl.focus_entered.connect(on_focus_entered)
	if ctrl: ctrl.focus_exited.connect(on_focus_exited)

func on_pressed(): if plays_on_pressed: play_sound()
func on_mouse_entered(): if plays_on_mouse_enter: play_sound()
func on_mouse_exited(): if plays_on_mouse_exit: play_sound()
func on_focus_entered(): if plays_on_focus_enter: play_sound()
func on_focus_exited(): if plays_on_focus_exit: play_sound()


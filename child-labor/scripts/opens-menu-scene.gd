class_name Z_OpensMenuScene extends Node

@export var target : BaseButton
@export var scene : PackedScene
@export var container : Node

@onready var sounds : Array[Node] = Z_ResolveUtil.resolve_all_at(get_parent(), Z_PlaySoundOnEvent, true)



func on_pressed():
	var instance : Control = scene.instantiate()
	var plays_on_focus_enter_arr : Array[bool] = []
	var plays_on_mouse_enter_arr : Array[bool] = []
	store_flags(plays_on_mouse_enter_arr, plays_on_focus_enter_arr)
	await Z_MenuTransitionUtil.menu_slide_down_in(target, instance, container)
	await target.focus_entered
	restore_flags(plays_on_mouse_enter_arr, plays_on_focus_enter_arr)

func store_flags(plays_on_mouse_enter_arr:Array[bool], plays_on_focus_enter_arr:Array[bool]):
	for sound in sounds:
		plays_on_focus_enter_arr.push_back(sound.plays_on_focus_enter)
		plays_on_mouse_enter_arr.push_back(sound.plays_on_mouse_enter)
		sound.plays_on_focus_enter = false
		sound.plays_on_mouse_enter = false

func restore_flags(plays_on_mouse_enter_arr:Array[bool], plays_on_focus_enter_arr:Array[bool]):
	for i in plays_on_focus_enter_arr.size():
		var plays_on_focus_enter : bool = plays_on_focus_enter_arr[i]
		var plays_on_mouse_enter : bool = plays_on_mouse_enter_arr[i]
		sounds[i].plays_on_focus_enter = plays_on_focus_enter
		sounds[i].plays_on_mouse_enter = plays_on_mouse_enter

func _ready() -> void:
	Z_ProcessAndPauseUtil.pause_always_process(self)
	if not target: if get_parent() is BaseButton: target = get_parent()
	if not target: push_error('parent must be a BaseButton %s' % get_path())
	if not scene: push_error('scene must be provided %s' % get_path())
	target.pressed.connect(on_pressed)

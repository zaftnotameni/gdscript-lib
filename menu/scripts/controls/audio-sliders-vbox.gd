class_name Z_AudioSliders_Node extends VBoxContainer

@onready var slider_master := Z_AudioSlider_Node.for_master()
@onready var slider_bgm := Z_AudioSlider_Node.for_bgm()
@onready var slider_sfx := Z_AudioSlider_Node.for_sfx()
@onready var slider_ui := Z_AudioSlider_Node.for_ui()

func _enter_tree() -> void:
	process_mode = ProcessMode.PROCESS_MODE_ALWAYS

func _ready() -> void:
	add_child.call_deferred(slider_master)
	add_spacer.call_deferred(false)
	add_child.call_deferred(slider_bgm)
	add_spacer.call_deferred(false)
	add_child.call_deferred(slider_sfx)
	add_spacer.call_deferred(false)
	add_child.call_deferred(slider_ui)


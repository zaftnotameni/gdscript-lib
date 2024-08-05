class_name Z_All extends Node

static var DIRECTOR : PackedScene = load('res://zaft/lib/audio/scenes/director.tscn')

var bus := Z_Bus.new()
var layer := Z_Layers.new()
var state := Z_State.new()
var audio : Z_AudioDirector_Scene

static func _static_init() -> void:
	Z_ProjectSettings.setup_default_project_metadata()
	Z_ProjectSettings.setup_default_project_settings()
	Z_ProjectSettings.setup_default_input_actions()

func _enter_tree() -> void:
	init_things()
	name_things()
	add_things()

func init_things():
	audio = DIRECTOR.instantiate()

func name_things():
	bus.name = "Bus"
	layer.name = "Layer"
	state.name = "State"
	audio.name = "Audio"

func add_things():
	add_child.call_deferred(bus)
	add_child.call_deferred(state)
	add_child.call_deferred(audio)
	add_child.call_deferred(layer)

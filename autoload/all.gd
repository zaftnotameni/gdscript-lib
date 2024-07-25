class_name Z_Autoload_All extends Node

var config := Z_Autoload_Config.new()
var util := Z_Autoload_Util.new()
var bus := Z_Autoload_Bus.new()
var layer := Z_Autoload_Layers.new()
var state := Z_Autoload_State.new()
var audio := Z_Autoload_Audio.new()
var menu := Z_Autoload_Menu.new()
var level := Z_Autoload_Level.new()
var environment := Z_Autoload_Environment.new()
var pool := Z_Autoload_Pool.new()
var query := Z_Autoload_Query.new()
var path := Z_Autoload_Path.new()
var global := Z_Autoload_Global.new()

func _ready():
  config.name = "Config"
  util.name = "Util"
  bus.name = "Bus"
  layer.name = "Layer"
  state.name = "State"
  audio.name = "Audio"
  menu.name = "Menu"
  level.name = "Level"
  environment.name = "Environment"
  pool.name = "Pool"
  query.name = "Query"
  path.name = "Path"
  add_child(config)
  add_child(util)
  add_child(bus)
  add_child(layer)
  add_child(state)
  add_child(audio)
  add_child(menu)
  add_child(level)
  add_child(environment)
  add_child(pool)
  add_child(query)
  add_child(path)

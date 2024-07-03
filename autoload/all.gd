class_name Zaft_Autoload_All extends Node

var config := Zaft_Autoload_Config.new()
var util := Zaft_Autoload_Util.new()
var bus := Zaft_Autoload_Bus.new()
var layer := Zaft_Autoload_Layers.new()
var state := Zaft_Autoload_State.new()
var audio := Zaft_Autoload_Audio.new()
var menu := Zaft_Autoload_Menu.new()
var level := Zaft_Autoload_Level.new()
var environment := Zaft_Autoload_Environment.new()
var pool := Zaft_Autoload_Pool.new()
var query := Zaft_Autoload_Query.new()
var path := Zaft_Autoload_Path.new()
var global := Zaft_Autoload_Global.new()

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



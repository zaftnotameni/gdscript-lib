@tool
class_name Zaft_DirWalker extends Node

signal sig_result_found(file_path:String)
signal sig_results_found(file_paths:Array[String])
signal sig_partial_results_found(file_paths:Array[String])

enum FT { Shader, Scene, Audio }

@export var file_type : FT
@export var base_path : String = 'res://'

var results := []

func _ready() -> void:
  find_files_recursive(base_path, matcher_for_file_type(file_type), results)
  for s:String in results:
    var sm := ShaderMaterial.new()
    sm.shader = load(s)
    sm.resource_local_to_scene = true
    var f : String = s.split('/')[-1]
    var sm_file_name : String = f.to_snake_case().replace('_', '-').split('.')[0]
    ResourceSaver.save(sm, 'res://zaft/output/materials/' + sm_file_name + '_material.tres')

static func is_file_ext(file_path:String,extensions:=[]) -> bool:
  if not file_path or file_path.is_empty(): return false
  if not extensions or extensions.is_empty(): return false
  for ext:String in extensions: if file_path.ends_with(ext): return true
  return false

static func is_shader_file(file_path:String) -> bool:
  return is_file_ext(file_path, ['.shader', '.gdshader'])

static func is_scene_file(file_path:String) -> bool:
  return is_file_ext(file_path, ['.tscn'])

static func is_audio_file(file_path:String) -> bool:
  return is_file_ext(file_path, ['.ogg', '.mp3', '.wav'])

static func matcher_for_file_type(ft:FT) -> Callable:
  match ft:
    FT.Shader: return is_shader_file
    FT.Scene: return is_scene_file
    FT.Audio: return is_audio_file
  return Callable()

static func find_files_recursive(path:String,fn_is_match:Callable,the_results:=[],depth:int=0):
  var dir = DirAccess.open(path)
  dir.list_dir_begin()
  while true:
    var file_name = dir.get_next()
    if not file_name or file_name.is_empty():
      break
    var file_path = path + ('' if path.ends_with('/') else '/') + file_name
    if file_path == 'res://addons': continue
    if dir.current_is_dir():
      find_files_recursive(file_path, fn_is_match, the_results, depth + 1)
    elif fn_is_match.call(file_path):
      the_results.push_back(file_path)
  dir.list_dir_end()

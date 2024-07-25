class_name Zaft_DirWalker extends Node

signal sig_result_found(file_path:String)
signal sig_results_found(file_paths:Array[String])
signal sig_partial_results_found(file_paths:Array[String])

enum FT { Shader, Scene, Audio, Material, Script, Particle, TileSet }

@export var base_path : String = 'res://'
@export var output_path : String = 'res://zaft/generated'

var results := {}

func create_if_needed(abs_path:String):
  if DirAccess.dir_exists_absolute(abs_path): return
  DirAccess.make_dir_recursive_absolute(abs_path)

func _ready() -> void:
  create_if_needed(output_path)
  find_files_recursive(base_path, results)
  create_materials_for_shaders()
  for k in results.keys():
    print_rich('\n[b]%s[/b]\n%s' % [FT.find_key(k), JSON.stringify(results[k], '\t')])
  create_all_for_scenes()
  create_all_for_audio()
  create_all_for_materials()
  create_all_for_shaders()
  create_all_for_tilesets()

func create_all_for_tilesets():
  var scripts_dir := generated_relative_dir_for(FT.Script)
  var script_contents := 'class_name Gen_AllTileSets extends Node\n'
  for s:String in results[FT.TileSet]:
    var file_name : String = s.split('/')[-1]
    var scene_name : String = file_name.to_pascal_case().replace('-', '_').to_upper().split('.')[0]
    script_contents += 'const TILESET_%s : TileSet = preload("%s")\n' % [scene_name, s]

  var f := FileAccess.open(scripts_dir.get_current_dir() + '/all-tilesets.gd', FileAccess.WRITE)
  f.store_string(script_contents)
  f.close()

func create_all_for_shaders():
  var scripts_dir := generated_relative_dir_for(FT.Script)
  var script_contents := 'class_name Gen_AllShaders extends Node\n'
  for s:String in results[FT.Shader]:
    var file_name : String = s.split('/')[-1]
    var scene_name : String = file_name.to_pascal_case().replace('-', '_').to_upper().split('.')[0]
    script_contents += 'const SHADER_%s : Shader = preload("%s")\n' % [scene_name, s]

  var f := FileAccess.open(scripts_dir.get_current_dir() + '/all-shaders.gd', FileAccess.WRITE)
  f.store_string(script_contents)
  f.close()

func create_all_for_materials():
  var scripts_dir := generated_relative_dir_for(FT.Script)
  var script_contents := 'class_name Gen_AllMaterials extends Node\n'
  var all_materials := '\nvar ALL_MATERIALS := ['
  for s:String in results[FT.Material]:
    var mt := 'ShaderMaterial' if load(s) is ShaderMaterial else 'CanvasItemMaterial'
    var file_name : String = s.split('/')[-1]
    var scene_name : String = file_name.to_pascal_case().replace('-', '_').to_upper().split('.')[0].trim_suffix('MATERIAL')
    script_contents += 'const MATERIAL_%s : %s = preload("%s")\n' % [scene_name, mt, s]
    all_materials += 'MATERIAL_' + scene_name + ','
  all_materials += ']\n'
  script_contents += all_materials
  var f := FileAccess.open(scripts_dir.get_current_dir() + '/all-materials.gd', FileAccess.WRITE)
  f.store_string(script_contents)
  f.close()

func create_all_for_audio():
  var scripts_dir := generated_relative_dir_for(FT.Script)
  var script_contents := 'class_name Gen_AllAudio extends Node\n'
  var all_audio := '\nvar ALL_AUDIO := ['
  for s:String in results[FT.Audio]:
    var file_name : String = s.split('/')[-1]
    var scene_name : String = file_name.to_pascal_case().replace('-', '_').to_upper().split('.')[0]
    script_contents += 'const AUDIO_%s : AudioStream = preload("%s")\n' % [scene_name, s]
    all_audio += 'AUDIO_' + scene_name + ','
  all_audio += ']\n'
  script_contents += all_audio
  var f := FileAccess.open(scripts_dir.get_current_dir() + '/all-audio.gd', FileAccess.WRITE)
  f.store_string(script_contents)
  f.close()

func create_all_for_scenes():
  var scripts_dir := generated_relative_dir_for(FT.Script)
  var script_contents := 'class_name Gen_AllScenes extends Node\n'
  for s:String in results[FT.Scene]:
    var file_name : String = s.split('/')[-1]
    var scene_name : String = file_name.to_pascal_case().replace('-', '_').to_upper().split('.')[0]
    script_contents += 'const SCENE_%s : PackedScene = preload("%s")\n' % [scene_name, s]

  var f := FileAccess.open(scripts_dir.get_current_dir() + '/all-scenes.gd', FileAccess.WRITE)
  f.store_string(script_contents)
  f.close()

func create_materials_for_shaders():
  var materials_dir := generated_relative_dir_for(FT.Material)
  for s:String in results[FT.Shader]:
    var sm := ShaderMaterial.new()
    sm.shader = load(s)
    sm.resource_local_to_scene = true
    var f : String = s.split('/')[-1]
    var sm_file_name : String = f.to_snake_case().replace('_', '-').split('.')[0]
    var m_file_name : String = materials_dir.get_current_dir() + '/' + sm_file_name + '_material.tres'
    ResourceSaver.save(sm, m_file_name)
    if not results.has(FT.Material):
      results[FT.Material] = []
    if not results[FT.Material].has(m_file_name):
      results[FT.Material].push_back(m_file_name)
    

static func is_file_ext(file_path:String,extensions:=[]) -> bool:
  if not file_path or file_path.is_empty(): return false
  if not extensions or extensions.is_empty(): return false
  for ext:String in extensions: if file_path.ends_with(ext): return true
  return false

static func is_particle_file(_file_path:String) -> bool:
  return false

static func is_tileset_file(file_path:String) -> bool:
  if not is_file_ext(file_path, ['.tres']): return false
  return load(file_path) is TileSet

static func is_material_file(file_path:String) -> bool:
  if not is_file_ext(file_path, ['.tres']): return false
  return load(file_path) is CanvasItemMaterial or load(file_path) is ShaderMaterial

static func is_shader_file(file_path:String) -> bool:
  return is_file_ext(file_path, ['.shader', '.gdshader'])

static func is_scene_file(file_path:String) -> bool:
  return is_file_ext(file_path, ['.tscn'])

static func is_audio_file(file_path:String) -> bool:
  return is_file_ext(file_path, ['.ogg', '.mp3', '.wav'])

static func is_not_interesting_file(_file_path:String='') -> bool:
  return false

func generated_relative_dir_for(ft:FT) -> DirAccess:
  var dir := DirAccess.open(output_path)
  var rel_path := generated_relative_folder_name_for(ft)
  if not dir.dir_exists(rel_path):
    dir.make_dir_recursive(rel_path)
  dir.change_dir(rel_path)
  return dir

static func generated_relative_folder_name_for(ft:FT) -> String:
  match ft:
    FT.Shader: return 'shaders'
    FT.Material: return 'materials'
    FT.Scene: return 'scenes'
    FT.Audio: return 'audio'
    FT.Script: return 'scripts'
    FT.Particle: return 'particles'
    FT.TileSet: return 'tilesets'
  return 'other'

static func matcher_for_file_type(ft:FT) -> Callable:
  match ft:
    FT.Particle: return is_particle_file
    FT.Material: return is_material_file
    FT.Shader: return is_shader_file
    FT.Scene: return is_scene_file
    FT.Audio: return is_audio_file
    FT.TileSet: return is_tileset_file
  return is_not_interesting_file

func find_files_recursive(path:String,the_results:={},depth:int=0):
  var dir = DirAccess.open(path)
  dir.list_dir_begin()
  while true:
    var file_name = dir.get_next()
    if not file_name or file_name.is_empty():
      break
    var file_path = path + ('' if path.ends_with('/') else '/') + file_name
    if file_path.contains('/.'): continue
    if file_path.contains('res://.'): continue
    if file_path.contains('res://addons'): continue
    if file_path.contains('res://zaft/test'): continue
    if file_path.contains(output_path): continue
    print(file_path)
    if dir.current_is_dir():
      find_files_recursive(file_path, the_results, depth + 1)
    else:
      for ft:FT in FT.values():
        var fn_is_match := matcher_for_file_type(ft)
        if fn_is_match.call(file_path):
          if not the_results.has(ft):
            the_results[ft] = []
          if not the_results[ft].has(file_path):
            the_results[ft].push_back(file_path)
          else:
            push_warning('found duplicated %s at %s' % [FT.find_key(ft), file_path])
  dir.list_dir_end()

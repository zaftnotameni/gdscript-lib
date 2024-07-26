@tool
class_name Z_ControlsSceneController extends Node

func clear_existing_node_named(n:String):
  if get_tree().edited_scene_root.has_node(n):
    var e := get_tree().edited_scene_root.get_node(n)
    e.queue_free()
    await e.tree_exited

func add_label_tool(lbl_txt:String) -> Label:
  var lbl_entry : CanvasItem = Label.new()
  lbl_entry.text = lbl_txt
  var n := 'Label' + lbl_txt
  lbl_entry.name =  n
  await clear_existing_node_named(n)
  Z_Autoload_Util.control_set_font_size(lbl_entry, 32)
  Z_Autoload_Util.tool_add_child_to_scene_root.call_deferred(lbl_entry)
  return lbl_entry

func add_hbox_tool(hbox_name:String) -> HBoxContainer:
  var entry : CanvasItem = HBoxContainer.new()
  var n := 'HBox' + hbox_name
  entry.name =  n
  await clear_existing_node_named(n)
  Z_Autoload_Util.tool_add_child_to_scene_root.call_deferred(entry)
  return entry

func add_scene_tool(scn_name:String, scn:PackedScene) -> CanvasItem:
  var entry : CanvasItem = scn.instantiate()
  var n := 'Scene' + scn_name
  entry.name = n
  await clear_existing_node_named(n)
  Z_Autoload_Util.tool_add_child_to_scene_root.call_deferred(entry)
  return entry

func on_editor_save_setup():
  await add_label_tool('Movement')
  var hbox := await add_hbox_tool('Movement')
  await hbox.ready
  Z_Autoload_Util.tool_add_child(hbox, Gen_AllScenes.SCENE_CONTROLS_WASD.instantiate(), get_tree().edited_scene_root)
  Z_Autoload_Util.tool_add_child(hbox, Gen_AllScenes.SCENE_CONTROLS_ARROWS.instantiate(), get_tree().edited_scene_root)
  await add_label_tool('MovementJoyPlaceholder')

  await add_label_tool('Jump')
  hbox = await add_hbox_tool('Jump')
  await hbox.ready
  var i := Z_InputIconControl.new()
  i.name = 'JumpSpace'
  i.k = Z_InputKey.K.Space
  i.texture = Gen_AllImages.IMAGE_KEYBOARD_SPACE_OUTLINE
  Z_Autoload_Util.tool_add_child(hbox, i, get_tree().edited_scene_root)
  await add_label_tool('JumpJoyPlaceholder')

  await add_label_tool('Dash')
  hbox = await add_hbox_tool('Dash')
  await hbox.ready
  i = Z_InputIconControl.new()
  i.name = 'DashShift'
  i.k = Z_InputKey.K.Shift
  i.texture = Gen_AllImages.IMAGE_KEYBOARD_SHIFT_OUTLINE
  Z_Autoload_Util.tool_add_child(hbox, i, get_tree().edited_scene_root)
  await add_label_tool('DashJoyPlaceholder')

  await add_label_tool('Respawn')
  hbox = await add_hbox_tool('Respawn')
  await hbox.ready
  i = Z_InputIconControl.new()
  i.name = 'RespawnR'
  i.k = Z_InputKey.K.R
  i.texture = Gen_AllImages.IMAGE_KEYBOARD_R_OUTLINE
  Z_Autoload_Util.tool_add_child(hbox, i, get_tree().edited_scene_root)
  await add_label_tool('RespawnJoyPlaceholder')

func on_editor_save_clear():
  pass

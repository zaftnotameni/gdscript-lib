@tool
class_name Z_ControlsSceneController extends Node

func clear_existing_node_named(n:String):
  if get_tree().edited_scene_root.has_node(n):
    var e := get_tree().edited_scene_root.get_node(n)
    e.queue_free()
    await e.tree_exited

func add_label_tool(lbl_txt:String, font_size:int=32, halign:=HORIZONTAL_ALIGNMENT_RIGHT) -> Label:
  var lbl_entry : CanvasItem = Label.new()
  lbl_entry.text = lbl_txt
  var n := 'Label' + lbl_txt
  lbl_entry.name =  n
  lbl_entry.horizontal_alignment = halign
  await clear_existing_node_named(n)
  Z_Autoload_Util.control_set_font_size(lbl_entry, font_size)
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
  await add_label_tool('Action', 32)
  await add_label_tool('Keyboard', 32, HORIZONTAL_ALIGNMENT_CENTER)
  await add_label_tool('Xbox', 32, HORIZONTAL_ALIGNMENT_LEFT)
  await add_label_tool('Playstation', 32, HORIZONTAL_ALIGNMENT_LEFT)

  await add_label_tool('Movement')
  var hbox := await add_hbox_tool('Movement')
  await hbox.ready
  Z_Autoload_Util.tool_add_child(hbox, Gen_AllScenes.SCENE_CONTROLS_WASD.instantiate(), get_tree().edited_scene_root)
  Z_Autoload_Util.tool_add_child(hbox, Gen_AllScenes.SCENE_CONTROLS_ARROWS.instantiate(), get_tree().edited_scene_root)
  hbox = await add_hbox_tool('MovementJoyPlaceholderX')
  await hbox.ready
  Z_Autoload_Util.tool_add_child(hbox, Z_InputIconControl.with_texture(Gen_AllImages.IMAGE_XBOX_DPAD_VERTICAL_OUTLINE), get_tree().edited_scene_root)
  Z_Autoload_Util.tool_add_child(hbox, Z_InputIconControl.with_texture(Gen_AllImages.IMAGE_XBOX_DPAD_HORIZONTAL_OUTLINE), get_tree().edited_scene_root)
  hbox = await add_hbox_tool('MovementJoyPlaceholderP')
  await hbox.ready
  Z_Autoload_Util.tool_add_child(hbox, Z_InputIconControl.with_texture(Gen_AllImages.IMAGE_PLAYSTATION_DPAD_VERTICAL_OUTLINE), get_tree().edited_scene_root)
  Z_Autoload_Util.tool_add_child(hbox, Z_InputIconControl.with_texture(Gen_AllImages.IMAGE_PLAYSTATION_DPAD_HORIZONTAL_OUTLINE), get_tree().edited_scene_root)

  await add_label_tool('Jump')
  hbox = await add_hbox_tool('Jump')
  await hbox.ready
  var i := Z_InputIconControl.new()
  i.name = 'JumpSpace'
  i.k = Z_InputKey.K.Space
  i.texture = Gen_AllImages.IMAGE_KEYBOARD_SPACE_OUTLINE
  Z_Autoload_Util.tool_add_child(hbox, i, get_tree().edited_scene_root)
  hbox = await add_hbox_tool('JumpJoyPlaceholderX')
  await hbox.ready
  Z_Autoload_Util.tool_add_child(hbox, Z_InputIconControl.with_texture(Gen_AllImages.IMAGE_XBOX_BUTTON_A_OUTLINE), get_tree().edited_scene_root)
  hbox = await add_hbox_tool('JumpJoyPlaceholderP')
  await hbox.ready
  Z_Autoload_Util.tool_add_child(hbox, Z_InputIconControl.with_texture(Gen_AllImages.IMAGE_PLAYSTATION_BUTTON_CROSS_OUTLINE), get_tree().edited_scene_root)

  await add_label_tool('Dash')
  hbox = await add_hbox_tool('Dash')
  await hbox.ready
  i = Z_InputIconControl.new()
  i.name = 'DashShift'
  i.k = Z_InputKey.K.Shift
  i.texture = Gen_AllImages.IMAGE_KEYBOARD_SHIFT_OUTLINE
  Z_Autoload_Util.tool_add_child(hbox, i, get_tree().edited_scene_root)
  hbox = await add_hbox_tool('DashJoyPlaceholderX')
  await hbox.ready
  Z_Autoload_Util.tool_add_child(hbox, Z_InputIconControl.with_texture(Gen_AllImages.IMAGE_XBOX_BUTTON_B_OUTLINE), get_tree().edited_scene_root)
  hbox = await add_hbox_tool('DashJoyPlaceholderP')
  await hbox.ready
  Z_Autoload_Util.tool_add_child(hbox, Z_InputIconControl.with_texture(Gen_AllImages.IMAGE_PLAYSTATION_BUTTON_CIRCLE_OUTLINE), get_tree().edited_scene_root)

  await add_label_tool('Respawn')
  hbox = await add_hbox_tool('Respawn')
  await hbox.ready
  i = Z_InputIconControl.new()
  i.name = 'RespawnR'
  i.k = Z_InputKey.K.R
  i.texture = Gen_AllImages.IMAGE_KEYBOARD_R_OUTLINE
  Z_Autoload_Util.tool_add_child(hbox, i, get_tree().edited_scene_root)
  hbox = await add_hbox_tool('RespawnJoyPlaceholderX')
  await hbox.ready
  Z_Autoload_Util.tool_add_child(hbox, Z_InputIconControl.with_texture(Gen_AllImages.IMAGE_XBOX_BUTTON_Y_OUTLINE), get_tree().edited_scene_root)
  hbox = await add_hbox_tool('RespawnJoyPlaceholderP')
  await hbox.ready
  Z_Autoload_Util.tool_add_child(hbox, Z_InputIconControl.with_texture(Gen_AllImages.IMAGE_PLAYSTATION_BUTTON_TRIANGLE_OUTLINE), get_tree().edited_scene_root)

func on_editor_save_clear():
  pass

@tool
class_name Z_ControlsSceneController extends Node

func _notification(what: int) -> void: Z_ToolScriptHelper.on_pre_save(what, on_pre_save)

func icon(tex:Texture2D) -> Z_InputIconControl:
	var texture_name := tex.resource_path.split('/')[-1].split('.')[0].to_pascal_case()
	return Z_InputIconControl.new().with_texture(tex).with_name(texture_name)

func wasd(parent:Node) -> GridContainer:
	var g := GridContainer.new()
	g.name = 'WASD'
	g.columns = 3
	await Z_ToolScriptHelper.tool_add_child(parent, g)
	await Z_ToolScriptHelper.tool_add_child(g, Label.new())
	await Z_ToolScriptHelper.tool_add_child(g, icon(Gen_AllImages.IMAGE_KEYBOARD_W_OUTLINE))
	await Z_ToolScriptHelper.tool_add_child(g, Label.new())
	await Z_ToolScriptHelper.tool_add_child(g, icon(Gen_AllImages.IMAGE_KEYBOARD_A_OUTLINE))
	await Z_ToolScriptHelper.tool_add_child(g, icon(Gen_AllImages.IMAGE_KEYBOARD_S_OUTLINE))
	await Z_ToolScriptHelper.tool_add_child(g, icon(Gen_AllImages.IMAGE_KEYBOARD_D_OUTLINE))
	return g

func arrows(parent:Node) -> GridContainer:
	var g := GridContainer.new()
	g.name = 'Arrows'
	g.columns = 3
	await Z_ToolScriptHelper.tool_add_child(parent, g)
	await Z_ToolScriptHelper.tool_add_child(g, Label.new())
	await Z_ToolScriptHelper.tool_add_child(g, icon(Gen_AllImages.IMAGE_KEYBOARD_ARROW_UP_OUTLINE))
	await Z_ToolScriptHelper.tool_add_child(g, Label.new())
	await Z_ToolScriptHelper.tool_add_child(g, icon(Gen_AllImages.IMAGE_KEYBOARD_ARROW_LEFT_OUTLINE))
	await Z_ToolScriptHelper.tool_add_child(g, icon(Gen_AllImages.IMAGE_KEYBOARD_ARROW_DOWN_OUTLINE))
	await Z_ToolScriptHelper.tool_add_child(g, icon(Gen_AllImages.IMAGE_KEYBOARD_ARROW_RIGHT_OUTLINE))
	return g

func xb_left_stick(parent:Node):
	await Z_ToolScriptHelper.tool_add_child(parent, icon(Gen_AllImages.IMAGE_XBOX_STICK_L))

func ps_left_stick(parent:Node):
	await Z_ToolScriptHelper.tool_add_child(parent, icon(Gen_AllImages.IMAGE_PLAYSTATION_STICK_L))

func xb_dpad(parent:Node):
	await Z_ToolScriptHelper.tool_add_child(parent, icon(Gen_AllImages.IMAGE_XBOX_DPAD_NONE))

func ps_dpad(parent:Node):
	await Z_ToolScriptHelper.tool_add_child(parent, icon(Gen_AllImages.IMAGE_PLAYSTATION_DPAD_NONE))

var pc : HBoxContainer
var xb : HBoxContainer
var ps : HBoxContainer
var lb : Z_ControlsActionLabel

func setup_row(txt:String):
	lb = Z_ControlsActionLabel.new().with_text(txt)
	pc = HBoxContainer.new()
	xb = HBoxContainer.new()
	ps = HBoxContainer.new()
	Z_ControlUtil.control_set_hshrink_center(xb)
	Z_ControlUtil.control_set_hshrink_center(ps)
	await Z_ToolScriptHelper.tool_add_child(owner, lb)
	await Z_ToolScriptHelper.tool_add_child(owner, pc)
	await Z_ToolScriptHelper.tool_add_child(owner, xb)
	await Z_ToolScriptHelper.tool_add_child(owner, ps)

func on_pre_save():
	await Z_ToolScriptHelper.remove_all_children_created_via_tool_from(owner)

	await setup_row('Movement')
	await arrows(pc)
	await wasd(pc)
	await xb_left_stick(xb)
	await ps_left_stick(ps)
	await xb_dpad(xb)
	await ps_dpad(ps)

	pc = null
	xb = null
	ps = null
	lb = null

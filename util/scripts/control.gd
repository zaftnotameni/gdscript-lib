class_name Z_ControlUtil extends RefCounted

static func control_set_margin(con:MarginContainer,margin:int=0):
	con.add_theme_constant_override(&'margin_left', margin)
	con.add_theme_constant_override(&'margin_right', margin)
	con.add_theme_constant_override(&'margin_top', margin)
	con.add_theme_constant_override(&'margin_bottom', margin)

static func control_set_bottom_right_min_size(con:Control):
	con.set_anchors_and_offsets_preset(Control.LayoutPreset.PRESET_BOTTOM_RIGHT, Control.LayoutPresetMode.PRESET_MODE_MINSIZE)

static func control_set_hshrink_center(con:Control):
	con.size_flags_horizontal = Control.SizeFlags.SIZE_SHRINK_CENTER

static func control_set_center_min_size(con:Control):
	con.set_anchors_and_offsets_preset(Control.LayoutPreset.PRESET_CENTER, Control.LayoutPresetMode.PRESET_MODE_MINSIZE)

static func control_set_top_left_min_size(con:Control):
	con.set_anchors_and_offsets_preset(Control.LayoutPreset.PRESET_TOP_LEFT, Control.LayoutPresetMode.PRESET_MODE_MINSIZE)

static func control_set_top_right_min_size(con:Control):
	con.set_anchors_and_offsets_preset(Control.LayoutPreset.PRESET_TOP_RIGHT, Control.LayoutPresetMode.PRESET_MODE_MINSIZE)

static func control_set_color(con:Control,col:Color=Color.HOT_PINK):
	con.add_theme_color_override("font_color",col)

static func control_set_font_size(con:Control,size:int=32):
	con.add_theme_font_size_override("font_size", size)

static func control_set_minimum_x(con:Control,x:float=100.0):
	con.custom_minimum_size.x = x

static func control_set_minimum_y(con:Control,y:float=100.0):
	con.custom_minimum_size.y = y


@tool
class_name Z_ControlsActionLabel extends Label

func _enter_tree() -> void:
	Z_ControlUtil.control_set_font_size(self, 32)
	Z_ControlUtil.control_label_justify_right(self)

func with_text(txt:String) -> Z_ControlsActionLabel:
	text = txt
	return self

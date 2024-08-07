@tool
class_name Z_FullScreenMenuMarginContainer extends MarginContainer

func _enter_tree() -> void:
	Z_ControlUtil.control_set_margin(self, 32)

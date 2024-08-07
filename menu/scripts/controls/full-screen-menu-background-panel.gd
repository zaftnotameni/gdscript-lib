@tool
class_name Z_FullScreenMenuBackgroundPanel extends PanelContainer

func _enter_tree() -> void:
	add_to_group('menu')
	add_to_group('closeable')
	Z_ControlUtil.control_set_full_rect(self)

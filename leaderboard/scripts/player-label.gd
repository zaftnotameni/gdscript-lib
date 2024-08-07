class_name Z_LeaderboardPlayerLabel extends Label

func _ready() -> void:
	Z_ControlUtil.control_set_font_size(self, 24)
	clip_text = true
	size_flags_horizontal = Control.SIZE_EXPAND_FILL

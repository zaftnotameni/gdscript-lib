class_name Z_LeaderboardTimeLabel extends Label

func _ready() -> void:
	Z_ControlUtil.control_set_font_size(self, 24)
	clip_text = true
	custom_minimum_size.x = 200
	size_flags_horizontal = Control.SIZE_SHRINK_END

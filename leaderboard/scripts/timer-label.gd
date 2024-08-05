class_name Z_TimerLabel extends Label

@onready var stopwatch : Z_Stopwatch = Z_Path.group_stopwatch_only_node()

func _process(_delta: float) -> void:
  text = Z_Util.string_format_time(stopwatch.elapsed)

func _enter_tree() -> void:
  process_mode = ProcessMode.PROCESS_MODE_ALWAYS

func _ready() -> void:
  Z_Util.control_set_font_size(self, 32)

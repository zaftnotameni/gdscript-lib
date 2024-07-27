class_name Z_BestLocalTimeLabel extends Label

@onready var localtimes : Z_LocalTimes = Z_Autoload_Path.group_local_times_only_node()
@onready var stopwatch : Z_Stopwatch = Z_Autoload_Path.group_stopwatch_only_node()

const DUMMY_TIME = (59.999) + (59 * 60) + (59 * 60 * 60)

func _enter_tree() -> void:
  process_mode = ProcessMode.PROCESS_MODE_ALWAYS

func _ready() -> void:
  Z_Autoload_Util.control_set_font_size(self, 32)
  localtimes.load_from_file()
  localtimes.add_local_time(stopwatch.elapsed if stopwatch.elapsed > 0 else DUMMY_TIME)
  text = Z_Autoload_Util.string_format_time(localtimes.best_time())

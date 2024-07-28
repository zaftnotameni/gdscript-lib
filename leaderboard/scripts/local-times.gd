class_name Z_LocalTimes extends Node

const LOCAL_TIMES_FILE_NAME := 'user://localtimes.json'

## each time as a float in seconds
@onready var local_times_top_10 : Array = []

func _enter_tree() -> void:
  add_to_group(Z_Autoload_Path.LOCAL_TIMES_GROUP)
  name = 'LocalTimes'

func _ready() -> void:
  load_from_file()

func create_local_file():
  var fa := FileAccess.open(LOCAL_TIMES_FILE_NAME, FileAccess.WRITE)
  fa.store_line(JSON.stringify(local_times_top_10))
  fa.close()

func load_from_file():
  if not FileAccess.file_exists(LOCAL_TIMES_FILE_NAME):
    local_times_top_10.resize(10)
    local_times_top_10.fill(-1)
    create_local_file()
  var fa := FileAccess.open(LOCAL_TIMES_FILE_NAME, FileAccess.READ)
  local_times_top_10 = JSON.parse_string(fa.get_line())
  fa.close()

func best_time() -> float:
  var best : float = -1
  for t in local_times_top_10:
    if best < 0: best = t; continue
    if t > 0 and t < best: best = t; continue
  return best

func add_local_time(new_local_time:float):
  if not G_State.allow_time_in_leaderboard: return
  for i in local_times_top_10.size():
    if local_times_top_10[i] <= 0 or local_times_top_10[i] > new_local_time:
      local_times_top_10[i] = new_local_time
      break
  local_times_top_10.sort()
  local_times_top_10.reverse()
  create_local_file()

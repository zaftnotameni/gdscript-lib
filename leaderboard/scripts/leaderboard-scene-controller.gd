class_name Z_LeaderboardSceneController extends Node

@onready var time_grid : GridContainer = %TimeGrid
@onready var local_grid : GridContainer = %OfflineGrid
@onready var input_name : LineEdit = %InputName
@onready var button_name : Button = %ButtonName
@onready var label_status : Label = %LabelStatus

var api : Z_LeaderboardApi
var local : Z_LocalTimes

func setup_local_times():
  local.load_from_file()
  var ts := []
  for lt in local.local_times_top_10: ts.push_front(lt)
  for lt in ts:
    if lt <= 1: continue
    var lbl_name := Z_LeaderboardPlayerLabel.new()
    var lbl_time := Z_LeaderboardTimeLabel.new()
    lbl_time.text = Z_Util.string_format_time(lt)
    lbl_name.text = 'Local Player'
    local_grid.add_child(lbl_name)
    local_grid.add_child(lbl_time)

func on_leaderboards(items:=[]):
  if items: label_status.text = 'Times retrieved: %s' % items.size()
  for grid_entry in time_grid.get_children():
    if [&'LabelPlayer', &'LabelTime', &'LabelYouTube'].has(grid_entry.name): continue
    grid_entry.queue_free()
  Z_LeaderboardApi.items_to_labels.call_deferred(time_grid, items, Z_LeaderboardPlayerLabel, Z_LeaderboardTimeLabel)

func on_player_name(p_name:='???'):
  label_status.text = 'Player name retrieved: %s' % p_name
  input_name.text = p_name

func on_button_name():
  if input_name.text and not input_name.text.is_empty():
    button_name.disabled = true
    input_name.editable = false
    label_status.text = 'Updating player name to: %s' % input_name.text
    api._change_player_name(input_name.text)

func on_set_name(p_name:='???'):
  label_status.text = 'Player name set: %s' % p_name
  button_name.disabled = false
  input_name.editable = true
  input_name.text = p_name
  label_status.text = 'Retrieving Times...'
  api._get_leaderboards()

func _ready() -> void:
  api = Z_Path.group_leaderboard_only_node()
  local = Z_Path.group_local_times_only_node()
  api.sig_leaderboard_request_completed.connect(on_leaderboards)
  api.sig_get_name_completed.connect(on_player_name)
  api.sig_set_name_completed.connect(on_set_name)
  button_name.pressed.connect(on_button_name)
  label_status.text = 'Retrieving Player Name and Times...'
  api._get_leaderboards()
  api._get_player_name()
  setup_local_times()

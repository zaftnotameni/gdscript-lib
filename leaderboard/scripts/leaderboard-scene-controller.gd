class_name Z_LeaderboardSceneController extends Node

@onready var time_grid : GridContainer = %TimeGrid
@onready var input_name : LineEdit = %InputName
@onready var button_name : Button = %ButtonName

var api : Z_LeaderboardApi

func on_leaderboards(items:=[]):
  Z_LeaderboardApi.items_to_labels(time_grid, items, Z_LeaderboardPlayerLabel, Z_LeaderboardTimeLabel)

func on_player_name(p_name:='???'):
  input_name.text = p_name

func on_button_name():
  if input_name.text and not input_name.text.is_empty():
    api._change_player_name(input_name.text)

func _ready() -> void:
  api = Z_Autoload_Path.group_leaderboard_only_node()
  api.sig_leaderboard_request_completed.connect(on_leaderboards)
  api.sig_get_name_completed.connect(on_player_name)
  api.sig_set_name_completed.connect(on_player_name)
  button_name.pressed.connect(on_button_name)
  api._get_leaderboards()
  api._get_player_name()

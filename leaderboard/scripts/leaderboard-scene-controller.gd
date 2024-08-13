class_name LootlockerSceneController extends Node

@onready var time_grid : GridContainer = %TimeGrid
@onready var input_name : LineEdit = %InputName
@onready var button_name : Button = %ButtonName
@onready var label_status : Label = %LabelStatus

var api : LootlockerAPI

func on_leaderboards(items:=[]):
  if items and not items.is_empty(): label_status.text = 'Showing Entries: 1-%s' % items.size()
  if not items or items.is_empty(): label_status.text = 'No entries yet, World Record for grabs!'
  for grid_entry in time_grid.get_children(): if grid_entry.get_meta('ephemeral', false): grid_entry.queue_free()
  LootlockerAPI.LootlockerDisplay.items_to_labels.call_deferred(time_grid, items)

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
  label_status.text = 'Retrieving Data...'
  api._get_leaderboards()

func _ready() -> void:
  api = await LootlockerAPI.singready()
  api.sig_leaderboard_request_completed.connect(on_leaderboards)
  api.sig_get_name_completed.connect(on_player_name)
  api.sig_set_name_completed.connect(on_set_name)
  button_name.pressed.connect(on_button_name)
  label_status.text = 'Retrieving Player Name and Data...'
  api._get_leaderboards()
  api._get_player_name()

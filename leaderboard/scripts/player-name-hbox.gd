@tool
class_name Z_LeaderboardPlayerNameHbox extends HBoxContainer

var api : Z_LootlockerAPI

func on_set_name_complete(new_name:String='New Name'):
  allow()
  input_name.text = new_name
  api._get_leaderboards()

func get_player_name_from_auth() -> String:
  if api.leaderboard_auth and api.leaderboard_auth.has('player_name') and api.leaderboard_auth.player_name:
    return api.leaderboard_auth.player_name
  return ''

func disallow():
  button_name.disabled = true
  input_name.editable = false

func allow():
  button_name.disabled = false
  input_name.editable = true

func on_auth_completed():
  allow()
  var pname := get_player_name_from_auth()
  if pname and not pname.is_empty(): input_name.text = pname

func on_button_name_pressed():
  if input_name.text and not input_name.text.is_empty():
    disallow()
    api._change_player_name(input_name.text)

func _ready() -> void:
  input_name = LineEdit.new()
  button_name = Button.new()
  disallow()
  input_name.placeholder_text = 'Enter Player Name'
  button_name.text = 'Update Name'
  input_name.size_flags_horizontal = Control.SizeFlags.SIZE_EXPAND_FILL
  Z_ControlUtil.control_set_font_size(button_name, 32)
  Z_ControlUtil.control_set_font_size(input_name, 32)
  add_child(input_name)
  add_child(button_name)
  button_name.pressed.connect(on_button_name_pressed)
  api = await Z_TreeUtil.tree_wait_for_ready(Z_LootlockerAPI.single())
  api.sig_set_name_completed.connect(on_set_name_complete)
  api.sig_auth_request_completed.connect(on_auth_completed)
  if api.fl_authenticated: on_auth_completed()

var input_name : LineEdit
var button_name : Button


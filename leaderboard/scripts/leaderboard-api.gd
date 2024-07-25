class_name Z_LeaderboardApi extends Node

signal sig_auth_request_completed()
signal sig_leaderboard_request_completed(items:Array)
signal sig_set_name_completed(name:String)
signal sig_get_name_completed(name:String)
signal sig_upload_completed()

@export_group('data')
@export var player_name := 'Reyalp %s' % randi()
@export var player_identifier : String
@export var score = -1

@export_group('auth')
@export var game_API_key = 'dev_cfead96600a040efa286a27bf7215909'
@export var leaderboard_key = 'fox2'
@export var development_mode = true
@export var session_token = ""
@export var auth_on_ready := false

var auth_http = HTTPRequest.new()
var leaderboard_http = HTTPRequest.new()
var submit_score_http = HTTPRequest.new()

var set_name_http = HTTPRequest.new()
var get_name_http = HTTPRequest.new()

const LL_DATA_FILE := 'user://lootlocker_data_%s.data'
const LL_USER_FILE := 'user://lootlocker_name_%s.data'
const LL_USER_FILE_GLOBAL := 'user://lootlocker_name_global.data'

@onready var data_file_for_leaderboard := LL_DATA_FILE % leaderboard_key
@onready var user_file_for_leaderboard := LL_USER_FILE % leaderboard_key

@export_group('flags')
@export var fl_authenticating := false
@export var fl_authenticated := false
@export var fl_name_set := false

var leaderboard_items = []
var leaderboard_user = {}
var leaderboard_auth = {}

func _ready() -> void:
  fl_name_set = name_file_exists()
  if name_file_exists():
    var name_file = FileAccess.open(user_file_for_leaderboard, FileAccess.READ)
    if name_file:
      player_name = name_file.get_as_text()
      print("player name="+player_name)
      name_file.close()
  if auth_on_ready:
    _authentication_request()

func name_file_global_exists():
  return FileAccess.file_exists(LL_USER_FILE_GLOBAL)

func name_file_exists():
  return FileAccess.file_exists(user_file_for_leaderboard)

func _authentication_request():
  if fl_authenticating: return
  fl_authenticating = true
  var player_session_exists = false
  var file = FileAccess.open(data_file_for_leaderboard, FileAccess.READ)
  if file:
    player_identifier = file.get_as_text()
    print("player ID="+player_identifier)
    file.close()
  var name_file = FileAccess.open(user_file_for_leaderboard, FileAccess.READ)
  if name_file:
    player_name = name_file.get_as_text()
    print("player name="+player_name)
    name_file.close()

  if player_identifier and player_identifier.length() > 1:
    print("player session exists, id="+player_identifier)
    player_session_exists = true
  if(player_identifier.length() > 1):
    player_session_exists = true

  var data = { "game_key": game_API_key, "game_version": "0.0.0.1", "development_mode": true }

  if(player_session_exists == true):
    data = { "game_key": game_API_key, "player_identifier":player_identifier, "game_version": "0.0.0.1", "development_mode": true }

  var headers = ["Content-Type: application/json"]

  auth_http = HTTPRequest.new()
  add_child(auth_http)
  auth_http.request_completed.connect(_on_authentication_request_completed)
  auth_http.request("https://api.lootlocker.io/game/v2/session/guest", headers, HTTPClient.METHOD_POST, JSON.stringify(data))
  print(data)

func _on_authentication_request_completed(_result, _response_code, _headers, body):
  var json = JSON.new()
  json.parse(body.get_string_from_utf8())
  prints(json.get_data())
  var file = FileAccess.open(data_file_for_leaderboard, FileAccess.WRITE)
  file.store_string(json.get_data()['player_identifier'])
  file.close()
  leaderboard_auth = json.get_data()
  session_token = json.get_data()['session_token']
  print(json.get_data())
  sig_auth_request_completed.emit()
  auth_http.queue_free()
  fl_authenticating = false

func _get_leaderboards():
  await wait_for_auth()
  print("Getting leaderboards")
  var url = "https://api.lootlocker.io/game/leaderboards/"+leaderboard_key+"/list?count=10"
  var headers = ["Content-Type: application/json", "x-session-token:"+session_token]
  leaderboard_http = HTTPRequest.new()
  add_child(leaderboard_http)
  leaderboard_http.request_completed.connect(_on_leaderboard_request_completed)
  leaderboard_http.request(url, headers, HTTPClient.METHOD_GET, "")

func _on_leaderboard_request_completed(_result, _response_code, _headers, body):
  var json = JSON.new()
  json.parse(body.get_string_from_utf8())
  print(json.get_data())
  var leaderboardFormatted = ""
  var items = json.get_data().items
  sig_leaderboard_request_completed.emit(items if items else [])
  leaderboard_items = (items if items else [])
  if items is Array: for n in items.size():
    leaderboardFormatted += str(json.get_data().items[n].rank)+str(". ")
    leaderboardFormatted += str(json.get_data().items[n].player.id)+str(" - ")
    leaderboardFormatted += str(json.get_data().items[n].score)+str("\n")
  print(leaderboardFormatted)
  leaderboard_http.queue_free()

func _upload_score(_score: int):
  await wait_for_auth()
  var data = { "score": str(_score) }
  var headers = ["Content-Type: application/json", "x-session-token:"+session_token]
  submit_score_http = HTTPRequest.new()
  add_child(submit_score_http)
  submit_score_http.request_completed.connect(_on_upload_score_request_completed)
  submit_score_http.request("https://api.lootlocker.io/game/leaderboards/"+leaderboard_key+"/submit", headers, HTTPClient.METHOD_POST, JSON.stringify(data))
  print(data)

func _change_player_name(new_name:String="new name"):
  await wait_for_auth()
  print("Changing player name")
  player_name = new_name
  var data = { "name": str(player_name) }
  var url =  "https://api.lootlocker.io/game/player/name"
  var headers = ["Content-Type: application/json", "x-session-token:"+session_token]
  set_name_http = HTTPRequest.new()
  add_child(set_name_http)
  set_name_http.request_completed.connect(_on_player_set_name_request_completed)
  set_name_http.request(url, headers, HTTPClient.METHOD_PATCH, JSON.stringify(data))

func _on_player_set_name_request_completed(_result, _response_code, _headers, body):
  var json = JSON.new()
  json.parse(body.get_string_from_utf8())
  print(json.get_data())
  set_name_http.queue_free()
  sig_set_name_completed.emit(player_name)
  var file = FileAccess.open(user_file_for_leaderboard, FileAccess.WRITE)
  file.store_string(player_name)
  file.close()
  var gfile = FileAccess.open(LL_USER_FILE_GLOBAL, FileAccess.WRITE)
  gfile.store_string(player_name)
  gfile.close()

func _get_player_name():
  await wait_for_auth()
  print("Getting player name")
  var url = "https://api.lootlocker.io/game/player/name"
  var headers = ["Content-Type: application/json", "x-session-token:"+session_token]
  get_name_http = HTTPRequest.new()
  add_child(get_name_http)
  get_name_http.request_completed.connect(_on_player_get_name_request_completed)
  get_name_http.request(url, headers, HTTPClient.METHOD_GET, "")

func _on_player_get_name_request_completed(_result, _response_code, _headers, body):
  var json = JSON.new()
  json.parse(body.get_string_from_utf8())
  leaderboard_user = json.get_data()
  printt(leaderboard_user)
  player_name = json.get_data().name
  sig_get_name_completed.emit(player_name)
  var file = FileAccess.open(user_file_for_leaderboard, FileAccess.WRITE)
  file.store_string(player_name)
  file.close()

func _on_upload_score_request_completed(_result, _response_code, _headers, body) :
  var json = JSON.new()
  json.parse(body.get_string_from_utf8())
  print(json.get_data())
  sig_upload_completed.emit() 
  submit_score_http.queue_free()

func wait_for_auth():
  if not leaderboard_auth:
    _authentication_request()
    await sig_auth_request_completed


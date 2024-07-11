class_name Zaft_LeaderboardApi extends Node

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
@export var game_API_key = "REDACTED"
@export var leaderboard_key = "REDACTED"
@export var development_mode = true
@export var session_token = ""

var auth_http = HTTPRequest.new()
var leaderboard_http = HTTPRequest.new()
var submit_score_http = HTTPRequest.new()

var set_name_http = HTTPRequest.new()
var get_name_http = HTTPRequest.new()

func _ready():
  _authentication_request()

func _authentication_request():
  var player_session_exists = false
  var file = FileAccess.open("user://LootLocker.data", FileAccess.READ)
  var name_file = FileAccess.open("user://LootLockerName.data", FileAccess.READ)
  if file != null:
    player_identifier = file.get_as_text()
    print("player ID="+player_identifier)
    file.close()
  if name_file != null:
    player_name = name_file.get_as_text()
    print("player name="+player_name)
    name_file.close()

  if player_identifier != null and player_identifier.length() > 1:
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

  var file = FileAccess.open("user://LootLocker.data", FileAccess.WRITE)
  file.store_string(json.get_data()['player_identifier'])
  file.close()

  session_token = json.get_data()['session_token']

  print(json.get_data())
  sig_auth_request_completed.emit()
  auth_http.queue_free()
  _get_leaderboards()

func _get_leaderboards():
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
  if items is Array: for n in items.size():
    leaderboardFormatted += str(json.get_data().items[n].rank)+str(". ")
    leaderboardFormatted += str(json.get_data().items[n].player.id)+str(" - ")
    leaderboardFormatted += str(json.get_data().items[n].score)+str("\n")
  print(leaderboardFormatted)

  leaderboard_http.queue_free()

func _upload_score(_score: int):
  var data = { "score": str(_score) }
  var headers = ["Content-Type: application/json", "x-session-token:"+session_token]
  submit_score_http = HTTPRequest.new()
  add_child(submit_score_http)
  submit_score_http.request_completed.connect(_on_upload_score_request_completed)
  submit_score_http.request("https://api.lootlocker.io/game/leaderboards/"+leaderboard_key+"/submit", headers, HTTPClient.METHOD_POST, JSON.stringify(data))
  print(data)

func _change_player_name(new_name:String="new name"):
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
  var file = FileAccess.open("user://LootLockerName.data", FileAccess.WRITE)
  file.store_string(player_name)
  file.close()

func _get_player_name():
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

  print(json.get_data())
  print(json.get_data().name)
  player_name = json.get_data().name
  sig_get_name_completed.emit(player_name)
  var file = FileAccess.open("user://LootLockerName.data", FileAccess.WRITE)
  file.store_string(player_name)
  file.close()

func _on_upload_score_request_completed(_result, _response_code, _headers, body) :
  var json = JSON.new()
  json.parse(body.get_string_from_utf8())

  print(json.get_data())
  sig_upload_completed.emit() 
  submit_score_http.queue_free()

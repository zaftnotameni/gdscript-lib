class_name Z_LootlockerAPI extends Node

@warning_ignore('unused_private_class_variable')
static var _instance : Z_LootlockerAPI
static func single() -> Z_LootlockerAPI: return Z_TreeUtil.singleton(Z_LootlockerAPI)

signal sig_auth_request_started()
signal sig_auth_request_completed()
signal sig_leaderboard_request_started()
signal sig_leaderboard_request_completed(items:Array)
signal sig_set_name_started()
signal sig_set_name_completed(name:String)
signal sig_get_name_started()
signal sig_get_name_completed(name:String)
signal sig_upload_started()
signal sig_upload_completed()

@export var player_data : Z_LeaderboardPlayerData

@export_group('auth')
@export var game_API_key = 'dev_cfead96600a040efa286a27bf7215909'
@export var leaderboard_key = 'fox2_dead'
@export var development_mode = true
@export var session_token = ''
@export var auth_on_ready := false

var auth_http : HTTPRequest
var leaderboard_http : HTTPRequest
var submit_score_http : HTTPRequest
var set_name_http : HTTPRequest
var get_name_http : HTTPRequest

@export_group('flags')
@export var fl_authenticating := false
@export var fl_authenticated := false
@export var fl_name_set := false

var leaderboard_items = []
var leaderboard_user = {}
var leaderboard_auth = {}

func _enter_tree() -> void:
	process_mode = ProcessMode.PROCESS_MODE_ALWAYS
	name = 'LeaderboardAPI'
	add_to_group(Z_Path.LEADERBOARD_GROUP)
	player_data = Z_LeaderboardPlayerData.from_existing()
	print_verbose("existing Lootlocker player name = " + str(player_data.lootlocker_player_name))
	if not OS.has_feature('web'): print_verbose("existing Lootlocker player ID = " + str(player_data.lootlocker_player_identifier))

func auths_on_ready(yes_or_no:=false) -> Z_LootlockerAPI:
	auth_on_ready = yes_or_no
	return self

func _ready() -> void:
	if not Z_Config.disable_remote_leaderboard:
		auth_http = HTTPRequest.new()
		leaderboard_http = HTTPRequest.new()
		submit_score_http = HTTPRequest.new()
		set_name_http = HTTPRequest.new()
		get_name_http = HTTPRequest.new()

	if auth_on_ready:
		_authentication_request()

func _authentication_request():
	if fl_authenticating: return
	sig_auth_request_started.emit()
	if Z_Config.disable_remote_leaderboard:
		sig_auth_request_completed.emit()
		return
	fl_authenticating = true
	var player_identifier_exists = false

	print_verbose("existing Lootlocker player name = " + str(player_data.lootlocker_player_name))
	if not OS.has_feature('web'): print_verbose("existing Lootlocker player ID = " + str(player_data.lootlocker_player_identifier))

	if player_data.lootlocker_player_identifier and not player_data.lootlocker_player_identifier.is_empty():
		if not OS.has_feature('web'): print_verbose("player session exists, id="+player_data.lootlocker_player_identifier)
		player_identifier_exists = true

	var data = { "game_key": game_API_key, "game_version": "0.0.0.1", "development_mode": true }

	if (player_identifier_exists):
		data = { "game_key": game_API_key, "player_identifier": player_data.lootlocker_player_identifier, "game_version": "0.0.0.1", "development_mode": true }

	var headers = ["Content-Type: application/json"]

	auth_http = HTTPRequest.new()
	add_child(auth_http)
	auth_http.request_completed.connect(_on_authentication_request_completed)
	auth_http.request("https://api.lootlocker.io/game/v2/session/guest", headers, HTTPClient.METHOD_POST, JSON.stringify(data))
	if not OS.has_feature('web'): print_verbose(data)
	fl_authenticated = true

func _on_authentication_request_completed(_result, _response_code, _headers, body):
	var json = JSON.new()
	json.parse(body.get_string_from_utf8())
	if not OS.has_feature('web'): print_verbose(json.get_data())
	var player_identifier := json.get_data()['player_identifier'] as String
	var player_name := json.get_data()['player_name'] as String
	player_data.lootlocker_player_identifier = player_identifier
	player_data.lootlocker_player_name = player_name
	if player_name and not player_name.is_empty():
		player_data.player_name = player_name
	player_data.save()
	leaderboard_auth = json.get_data()
	session_token = json.get_data()['session_token']
	sig_auth_request_completed.emit()
	auth_http.queue_free()
	fl_authenticating = false

func _get_leaderboards():
	await wait_for_auth()
	sig_leaderboard_request_started.emit()
	if Z_Config.disable_remote_leaderboard:
		sig_leaderboard_request_completed.emit([])
		return
	print_verbose("Getting leaderboards")
	var url = "https://api.lootlocker.io/game/leaderboards/"+leaderboard_key+"/list?count=50"
	var headers = ["Content-Type: application/json", "x-session-token:"+session_token]
	leaderboard_http = HTTPRequest.new()
	add_child(leaderboard_http)
	leaderboard_http.request_completed.connect(_on_leaderboard_request_completed)
	leaderboard_http.request(url, headers, HTTPClient.METHOD_GET, "")

func _on_leaderboard_request_completed(_result, _response_code, _headers, body):
	var json = JSON.new()
	json.parse(body.get_string_from_utf8())
	print_verbose(json.get_data())
	var leaderboardFormatted = ""
	var items = json.get_data().items
	sig_leaderboard_request_completed.emit(items if items else [])
	leaderboard_items = (items if items else [])
	if items is Array: for n in items.size():
		leaderboardFormatted += str(json.get_data().items[n].rank)+str(". ")
		leaderboardFormatted += str(json.get_data().items[n].player.id)+str(" - ")
		leaderboardFormatted += str(json.get_data().items[n].score)+str("\n")
	print_verbose(leaderboardFormatted)
	leaderboard_http.queue_free()

func _upload_score(_score: int):
	await wait_for_auth()
	sig_upload_started.emit()
	if Z_Config.disable_remote_leaderboard:
		sig_upload_completed.emit()
		return
	var data = { "score": str(_score) }
	var headers = ["Content-Type: application/json", "x-session-token:"+session_token]
	submit_score_http = HTTPRequest.new()
	add_child(submit_score_http)
	submit_score_http.request_completed.connect(_on_upload_score_request_completed)
	submit_score_http.request("https://api.lootlocker.io/game/leaderboards/"+leaderboard_key+"/submit", headers, HTTPClient.METHOD_POST, JSON.stringify(data))
	print_verbose(data)

func _change_player_name(new_name:String="new name"):
	await wait_for_auth()
	sig_set_name_started.emit()
	if Z_Config.disable_remote_leaderboard:
		sig_set_name_completed.emit(new_name)
		return
	print_verbose("Changing player name")
	player_data.lootlocker_player_name = new_name
	player_data.player_name = new_name
	var data = { "name": str(player_data.player_name) }
	var url = "https://api.lootlocker.io/game/player/name"
	var headers = ["Content-Type: application/json", "x-session-token:"+session_token]
	set_name_http = HTTPRequest.new()
	add_child(set_name_http)
	set_name_http.request_completed.connect(_on_player_set_name_request_completed)
	set_name_http.request(url, headers, HTTPClient.METHOD_PATCH, JSON.stringify(data))

func _on_player_set_name_request_completed(_result, _response_code, _headers, body):
	var json = JSON.new()
	json.parse(body.get_string_from_utf8())
	print_verbose(json.get_data())
	set_name_http.queue_free()
	player_data.save()
	sig_set_name_completed.emit(player_data.player_name)

func _get_player_name():
	await wait_for_auth()
	sig_get_name_started.emit()
	if Z_Config.disable_remote_leaderboard:
		sig_get_name_completed.emit('offline')
		return
	print_verbose("Getting player name")
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
	print_verbose(leaderboard_user)
	var new_name := json.get_data().name as String
	player_data.lootlocker_player_name = new_name
	player_data.player_name = new_name
	player_data.save()
	sig_get_name_completed.emit(player_data.player_name)

func _on_upload_score_request_completed(_result, _response_code, _headers, body) :
	var json = JSON.new()
	json.parse(body.get_string_from_utf8())
	print_verbose(json.get_data())
	sig_upload_completed.emit() 
	submit_score_http.queue_free()

func wait_for_auth():
	if Z_Config.disable_remote_leaderboard: return
	if not leaderboard_auth:
		_authentication_request()
		await sig_auth_request_completed

static func player_name_from_item(item:={}) -> String:
	if item:
		if item.has('player'):
			if item.player:
				if item.player.has('name'):
					if item.player.name:
						if not item.player.name.is_empty():
							return item.player.name
				if item.player.has('public_uid'):
					if item.player.public_uid:
						if not item.player.public_uid.is_empty():
							return item.player.public_uid
	return '??????'

static func time_from_item_in_seconds(item:={}) -> float:
	if item:
		if item.has('score'):
			if item.score > 0:
				return item.score / 1000.0
	return -1

## parent: ideally a grid container with 2 columns
static func items_to_labels(parent: Node, items:=[], NameLabelType:Script=null, TimeLabelType:Script=null):
	if items and not items.is_empty():
		for item in items:
			var p_name := player_name_from_item(item)
			var time_in_sec := time_from_item_in_seconds(item)
			var lbl_name :Control
			var lbl_time :Control = TimeLabelType.new() if TimeLabelType else Label.new()
			var btn_yt : Control
			lbl_time.text = Z_Util.string_format_time(time_in_sec)
			lbl_name = NameLabelType.new() if NameLabelType else Label.new()
			btn_yt = Label.new()
			lbl_name.text = p_name
			Z_ControlUtil.control_set_font_size(lbl_name, 24)
			var margin_container := MarginContainer.new()
			margin_container.add_theme_constant_override(&'margin_right', 12)
			margin_container.add_child(btn_yt)
			parent.add_child(margin_container)
			parent.add_child(lbl_name)
			parent.add_child(lbl_time)

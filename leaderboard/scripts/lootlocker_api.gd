class_name LootlockerAPI extends Node

signal sig_auth_request_started()
signal sig_auth_request_completed()
signal sig_leaderboard_request_started()
signal sig_leaderboard_request_completed()
signal sig_set_name_started()
signal sig_set_name_completed()
signal sig_get_name_started()
signal sig_get_name_completed()
signal sig_upload_started()
signal sig_upload_completed()

@export_group('auth')
@export var lootlocker_secrets : LootlockerSecrets
@export var development_mode : bool = true
@export var auth_on_ready : bool = false
@export var disable_remote_leaderboard : bool = false

var session_token : String = ''
var auth_http : HTTPRequest
var leaderboard_http : HTTPRequest
var submit_score_http : HTTPRequest
var set_name_http : HTTPRequest
var get_name_http : HTTPRequest

var fl_authenticating := false
var fl_authenticated := false

var leaderboard_items = []
var leaderboard_user = {}
var leaderboard_auth = {}
var player_data : LootlockerPlayer

func _enter_tree() -> void:
	process_mode = ProcessMode.PROCESS_MODE_ALWAYS
	name = 'LootlockerAPI'
	add_to_group(LOOTLOCKER_API_GROUP)
	player_data = LootlockerPlayer.from_existing()
	lootlocker_secrets = LootlockerSecrets.from_file()
	print_verbose("existing Lootlocker player name = " + str(player_data.lootlocker_player_name))
	if not OS.has_feature('web'): print_verbose("existing Lootlocker player ID = " + str(player_data.lootlocker_player_identifier))

func auths_on_ready(yes_or_no:=false) -> LootlockerAPI:
	auth_on_ready = yes_or_no
	return self

func _ready() -> void:
	if not disable_remote_leaderboard:
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
	if disable_remote_leaderboard:
		sig_auth_request_completed.emit()
		return
	fl_authenticating = true
	var player_identifier_exists = false
	var game_api_key := lootlocker_secrets.game_api_key

	print_verbose("existing Lootlocker player name = " + str(player_data.lootlocker_player_name))
	if not OS.has_feature('web'): print_verbose("existing Lootlocker player ID = " + str(player_data.lootlocker_player_identifier))

	if player_data.lootlocker_player_identifier and not player_data.lootlocker_player_identifier.is_empty():
		if not OS.has_feature('web'): print_verbose("player session exists, id="+player_data.lootlocker_player_identifier)
		player_identifier_exists = true

	var data = { "game_key": game_api_key, "game_version": "0.0.0.1", "development_mode": true }

	if (player_identifier_exists):
		data = { "game_key": game_api_key, "player_identifier": player_data.lootlocker_player_identifier, "game_version": "0.0.0.1", "development_mode": true }

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
	if disable_remote_leaderboard:
		sig_leaderboard_request_completed.emit([])
		return
	print_verbose("Getting leaderboards")
	var leaderboard_key := lootlocker_secrets.leaderboard_key
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
	if disable_remote_leaderboard:
		sig_upload_completed.emit()
		return
	var leaderboard_key := lootlocker_secrets.leaderboard_key
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
	if disable_remote_leaderboard:
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
	if disable_remote_leaderboard:
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
	if disable_remote_leaderboard: return
	if not leaderboard_auth:
		_authentication_request()
		await sig_auth_request_completed

const LOOTLOCKER_API_GROUP := 'lootlocker_api_group'

@warning_ignore('unused_private_class_variable')
static var _instance : LootlockerAPI
static func single() -> LootlockerAPI: return LootlockerTreeUtil.singleton(LootlockerAPI)
static func singready() -> LootlockerAPI: return await LootlockerTreeUtil.tree_wait_for_ready(single())

class LootlockerPlayerLabel extends Label:
	func with_text(txt:String) -> LootlockerPlayerLabel: text = txt; return self
	func from_item(item:Dictionary) -> LootlockerPlayerLabel: return with_text(LootlockerItem.player_name_from_item(item))
	func ephemeral() -> LootlockerPlayerLabel: set_meta('ephemeral', true); return self

class LootlockerScoreLabel extends Label:
	func with_text(txt:String) -> LootlockerScoreLabel: text = txt; return self
	func from_item(item:Dictionary) -> LootlockerScoreLabel: return with_text(LootlockerDisplay.string_format_time(LootlockerItem.time_from_item_in_seconds(item)))
	func ephemeral() -> LootlockerScoreLabel: set_meta('ephemeral', true); return self

class LootlockerItem extends RefCounted:
	static func player_name_from_item(item:={}) -> String:
		if item and item.has('player') and item.player and item.player.has('name') and item.player.name and not item.player.name.is_empty(): return item.player.name
		if item and item.has('player') and item.player and item.player.has('public_uid') and item.player.public_uid and not item.player.public_uid.is_empty(): return item.player.public_uid
		return ''

	static func time_from_item_in_seconds(item:={}) -> float:
		if item and item.has('score') and item.score > 0: return item.score / 1000.0
		return -1

class LootlockerDisplay extends RefCounted:
	static func string_format_time(time_seconds: float) -> String:
		if time_seconds <= 0: return '--:--:--.---'
		var total_seconds = int(time_seconds)
		var milliseconds = int((time_seconds - total_seconds) * 1000)
		
		var seconds = total_seconds % 60
		@warning_ignore(&'integer_division')
		var minutes = (total_seconds / 60) % 60
		@warning_ignore(&'integer_division')
		var hours = total_seconds / 3600

		var formatted_time = "%02d:%02d:%02d.%03d" % [hours, minutes, seconds, milliseconds]
		
		return formatted_time

	## parent: ideally a grid container with 2 columns
	static func items_to_labels(parent: Node, items:Array=[]):
		if items and not items.is_empty():
			for item in items:
				parent.add_child(LootlockerPlayerLabel.new().from_item(item).ephemeral())
				parent.add_child(LootlockerScoreLabel.new().from_item(item).ephemeral())

class LootlockerTreeUtil extends RefCounted:
	static func tree_wait_for_ready(node:Node) -> Node:
		if node.is_node_ready(): return node
		await node.ready
		return node

	static func singleton(TypeScript:Script) -> Node:
		var existing = TypeScript['_instance']; if existing: return existing
		var instance = TypeScript.new(); TypeScript['_instance'] = instance
		return tree_node_at_root(instance)

	static func scene_tree() -> SceneTree: return Engine.get_main_loop()
	static func current_scene() -> Node: return Engine.get_main_loop().current_scene

	static func tree_node_at_root(node:Node) -> Node:
		var scn : Node = scene_tree().root
		if node.is_inside_tree(): return node
		if node.has_meta('singleton_instance_setup') and node.get_meta('singleton_instance_setup'): return node
		node.set_meta('singleton_instance_setup', true)
		var script:Script = node.get_script()
		if script and script.get_global_name(): node.name = script.get_global_name()
		scn.add_child.call_deferred(node)
		return node

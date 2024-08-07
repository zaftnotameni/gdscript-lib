class_name Z_LeaderboardPlayerData extends Resource

@export var player_name : String = 'no name %s' % randi()
@export var player_score : int = -1
@export var lootlocker_player_identifier : String = ''
@export var lootlocker_player_name : String = ''
@export var lootlocker_player_score : int = -1

const PLAYER_DATA_FILE_NAME : String = 'user://leaderboard-player-data.tres'

static func copy(from:Z_LeaderboardPlayerData, to:Z_LeaderboardPlayerData) -> Z_LeaderboardPlayerData:
	to.player_name = from.player_name
	to.player_score = from.player_score
	to.lootlocker_player_identifier = from.lootlocker_player_identifier
	to.lootlocker_player_name = from.lootlocker_player_name
	to.lootlocker_player_score = from.lootlocker_player_score
	return to

static func initialize_from_web(data:Z_LeaderboardPlayerData) -> Z_LeaderboardPlayerData:
	if not OS.has_feature('web'): return data
	var loaded := Z_LeaderboardPlayerData.new()
	loaded.player_name = Z_LocalStorageBridge.local_storage_get_or_set_item('player_name', loaded.player_name)
	loaded.player_score = int(Z_LocalStorageBridge.local_storage_get_or_set_item('player_score', str(loaded.player_score)))
	loaded.lootlocker_player_identifier = Z_LocalStorageBridge.local_storage_get_or_set_item('lootlocker_player_identifier', loaded.lootlocker_player_identifier)
	loaded.lootlocker_player_name = Z_LocalStorageBridge.local_storage_get_or_set_item('lootlocker_player_name', loaded.lootlocker_player_name)
	loaded.lootlocker_player_score = int(Z_LocalStorageBridge.local_storage_get_or_set_item('lootlocker_player_score', str(loaded.lootlocker_player_score)))
	copy(loaded, data)
	return data

static func initialize_from_file(data:Z_LeaderboardPlayerData) -> Z_LeaderboardPlayerData:
	if not ResourceLoader.exists(PLAYER_DATA_FILE_NAME): ResourceSaver.save(data, PLAYER_DATA_FILE_NAME)
	var loaded := ResourceLoader.load(PLAYER_DATA_FILE_NAME) as Z_LeaderboardPlayerData
	return copy(loaded, data)

static func save_to_web(data:Z_LeaderboardPlayerData) -> Z_LeaderboardPlayerData:
	if not OS.has_feature('web'): return data
	Z_LocalStorageBridge.local_storage_set_item('player_name', data.player_name)
	Z_LocalStorageBridge.local_storage_set_item('player_score', str(data.player_score))
	Z_LocalStorageBridge.local_storage_set_item('lootlocker_player_identifier', data.lootlocker_player_identifier)
	Z_LocalStorageBridge.local_storage_set_item('lootlocker_player_name', data.lootlocker_player_name)
	Z_LocalStorageBridge.local_storage_set_item('lootlocker_player_score', str(data.lootlocker_player_score))
	return data

static func save_to_file(data:Z_LeaderboardPlayerData) -> Z_LeaderboardPlayerData:
	ResourceSaver.save(data, PLAYER_DATA_FILE_NAME)
	return data

func save() -> Z_LeaderboardPlayerData:
	if OS.has_feature('web'): save_to_web(self)
	else: save_to_file(self)
	return self

static func from_existing() -> Z_LeaderboardPlayerData:
	var data := Z_LeaderboardPlayerData.new()
	if OS.has_feature('web'): initialize_from_web(data)
	else: initialize_from_file(data)
	return data

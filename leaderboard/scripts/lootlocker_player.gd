class_name LootlockerPlayer extends Resource

@export var player_name : String = 'no name %s' % randi()
@export var player_score : int = -1
@export var lootlocker_player_identifier : String = ''
@export var lootlocker_player_name : String = ''
@export var lootlocker_player_score : int = -1

const PLAYER_DATA_FILE_NAME : String = 'user://lootlocker_player_data.tres'

static func copy(from:LootlockerPlayer, to:LootlockerPlayer) -> LootlockerPlayer:
	to.player_name = from.player_name
	to.player_score = from.player_score
	to.lootlocker_player_identifier = from.lootlocker_player_identifier
	to.lootlocker_player_name = from.lootlocker_player_name
	to.lootlocker_player_score = from.lootlocker_player_score
	return to

static func initialize_from_web(data:LootlockerPlayer) -> LootlockerPlayer:
	if not OS.has_feature('web'): return data
	var loaded := LootlockerPlayer.new()
	loaded.player_name = LocalStorageBridge.local_storage_get_or_set_item('player_name', loaded.player_name)
	loaded.player_score = int(LocalStorageBridge.local_storage_get_or_set_item('player_score', str(loaded.player_score)))
	loaded.lootlocker_player_identifier = LocalStorageBridge.local_storage_get_or_set_item('lootlocker_player_identifier', loaded.lootlocker_player_identifier)
	loaded.lootlocker_player_name = LocalStorageBridge.local_storage_get_or_set_item('lootlocker_player_name', loaded.lootlocker_player_name)
	loaded.lootlocker_player_score = int(LocalStorageBridge.local_storage_get_or_set_item('lootlocker_player_score', str(loaded.lootlocker_player_score)))
	copy(loaded, data)
	return data

static func initialize_from_file(data:LootlockerPlayer) -> LootlockerPlayer:
	if not ResourceLoader.exists(PLAYER_DATA_FILE_NAME): ResourceSaver.save(data, PLAYER_DATA_FILE_NAME)
	var loaded := ResourceLoader.load(PLAYER_DATA_FILE_NAME)
	return copy(loaded, data)

static func save_to_web(data:LootlockerPlayer) -> LootlockerPlayer:
	if not OS.has_feature('web'): return data
	LocalStorageBridge.local_storage_set_item('player_name', data.player_name)
	LocalStorageBridge.local_storage_set_item('player_score', str(data.player_score))
	LocalStorageBridge.local_storage_set_item('lootlocker_player_identifier', data.lootlocker_player_identifier)
	LocalStorageBridge.local_storage_set_item('lootlocker_player_name', data.lootlocker_player_name)
	LocalStorageBridge.local_storage_set_item('lootlocker_player_score', str(data.lootlocker_player_score))
	return data

static func save_to_file(data:LootlockerPlayer) -> LootlockerPlayer:
	ResourceSaver.save(data, PLAYER_DATA_FILE_NAME)
	return data

func save() -> LootlockerPlayer:
	if OS.has_feature('web'): save_to_web(self)
	else: save_to_file(self)
	return self

static func from_existing() -> LootlockerPlayer:
	var data := LootlockerPlayer.new()
	if OS.has_feature('web'): initialize_from_web(data)
	else: initialize_from_file(data)
	return data

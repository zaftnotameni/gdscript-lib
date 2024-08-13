class_name LootlockerSecrets extends Resource

const LOOTLOCKER_SECRETS_FILE_NAME : String = 'res://lootlocker_secrets.tres'

@export var game_api_key : String
@export var leaderboard_key : String

static func from_file() -> LootlockerSecrets:
	return load(LOOTLOCKER_SECRETS_FILE_NAME)

func save() -> LootlockerSecrets:
	ResourceSaver.save(self, LOOTLOCKER_SECRETS_FILE_NAME)
	return self

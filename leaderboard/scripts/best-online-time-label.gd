class_name Z_BestOnlineTimeLabel extends Label

var api : LootlockerAPI
@onready var stopwatch : Z_Stopwatch = Z_Path.group_stopwatch_only_node()

const DUMMY_TIME = (59.999) + (59 * 60) + (59 * 60 * 60)

func on_leaderboards(items:=[]):
	if items and not items.is_empty():
		var n := LootlockerAPI.player_name_from_item(items[0])
		var t := LootlockerAPI.time_from_item_in_seconds(items[0])
		text = '%s by %s' % [Z_Util.string_format_time(t), n]
	else:
		text = 'No Online Scores'

func on_upload():
	api._get_leaderboards()

func _enter_tree() -> void:
	process_mode = ProcessMode.PROCESS_MODE_ALWAYS

func _ready() -> void:
	text = 'Loading'
	api = await Z_TreeUtil.tree_wait_for_ready(LootlockerAPI.single())
	api.sig_leaderboard_request_completed.connect(on_leaderboards)
	api.sig_upload_completed.connect(on_upload)
	api._upload_score(roundi(1000 * (stopwatch.elapsed if stopwatch.elapsed > 0 else DUMMY_TIME)))

class_name Z_LocalTimes extends Node

@warning_ignore('unused_private_class_variable')
static var _instance : Z_LocalTimes
static func single() -> Z_LocalTimes: return Z_TreeUtil.singleton(Z_LocalTimes)

@export var local_times_data : Z_LocalTimesData

func _enter_tree() -> void:
	add_to_group(Z_Path.LOCAL_TIMES_GROUP)
	name = 'LocalTimes'
	local_times_data = Z_LocalTimesData.from_existing()

func best_time() -> float: return local_times_data.best_time()
func add_local_time(new_local_time:float) -> Z_LocalTimesData: return local_times_data.add_local_time(new_local_time)

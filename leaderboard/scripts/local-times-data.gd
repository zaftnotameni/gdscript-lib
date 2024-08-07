class_name Z_LocalTimesData extends Resource

## each time as a float in seconds
@export var top_50 : Array = []

const LOCAL_TIMES_FILE_NAME := 'user://local-times.tres'

static func from_existing() -> Z_LocalTimesData:
	if not ResourceLoader.exists(LOCAL_TIMES_FILE_NAME):
		var fresh := Z_LocalTimesData.new()
		fresh.top_50.resize(50)
		fresh.top_50.fill(-1)
		ResourceSaver.save(fresh, LOCAL_TIMES_FILE_NAME)
	return ResourceLoader.load(LOCAL_TIMES_FILE_NAME)

func best_time() -> float:
	var best : float = -1
	for t in top_50:
		if best < 0: best = t; continue
		if t > 0 and t < best: best = t; continue
	return best

func add_local_time(new_local_time:float) -> Z_LocalTimesData:
	for i in top_50.size():
		if top_50[i] <= 0 or top_50[i] > new_local_time:
			top_50[i] = new_local_time
			break
	top_50.sort()
	top_50.reverse()
	return save()

func save() -> Z_LocalTimesData:
	ResourceSaver.save(self, LOCAL_TIMES_FILE_NAME)
	return self

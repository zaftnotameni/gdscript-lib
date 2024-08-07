class_name Z_LocalStorageBridge extends RefCounted

static func is_on_web() -> bool: return OS.has_feature('web')

static func local_storage_set_item(key:String, value:String) -> void:
	if not is_on_web(): return
	JavaScriptBridge.eval('localStorage.setItem("%s", "%s")' % [key, value])

static func local_storage_get_item(key:String) -> String:
	if not is_on_web(): return ""
	var existing := JavaScriptBridge.eval('localStorage.getItem("%s")' % [key]) as String
	if existing: return existing
	else: return ""

static func local_storage_get_or_set_item(key:String, default_value:String) -> String:
	if not is_on_web(): return ""
	var existing := local_storage_get_item(key) as String
	if existing and not existing.is_empty(): return existing
	else:
		local_storage_set_item(key, default_value)
		return default_value

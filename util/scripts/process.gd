class_name Z_ProcessAndPauseUtil extends RefCounted

static func pause_never_process(_b:Node):
	_b.process_mode = Node.PROCESS_MODE_DISABLED

static func pause_always_process(_b:Node):
	_b.process_mode = Node.PROCESS_MODE_ALWAYS

static func pause_respects_pause(_b:Node):
	_b.process_mode = Node.PROCESS_MODE_PAUSABLE

static func pause_inherits(_b:Node):
	_b.process_mode = Node.PROCESS_MODE_INHERIT

static func node_turn_off(_b:Node):
	if not _b: return
	_b.hide()
	_b.process_mode = Node.PROCESS_MODE_DISABLED

static func node_turn_on(_b:Node):
	if not _b: return
	_b.process_mode = Node.PROCESS_MODE_INHERIT
	_b.show()


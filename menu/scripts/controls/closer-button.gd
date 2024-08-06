@tool
class_name Z_CloserButton extends Button

@export var target : Node

const TARGET_GROUPS = [
	"popup",
	"sub-menu",
	"closeable",
]

const TARGET_META = [
	"popup",
	"sub-menu",
	"closeable",
]

const TARGET_ACTIONS = [
	"menu-close",
	"menu-back",
]

func _enter_tree() -> void:
	Z_ControlUtil.control_set_font_size(self, 32)

func close_target(): Z_MenuTransitionUtil.menu_slide_up_out(target)

func _ready() -> void:
	text = "Close"
	process_mode = ProcessMode.PROCESS_MODE_ALWAYS
	if not target: target = find_closeable_parent()
	pressed.connect(close_target)

func _unhandled_input(event: InputEvent) -> void:
	if TARGET_ACTIONS.any(event.is_action_pressed):
		get_viewport().set_input_as_handled()
		close_target()

func find_closeable_parent(n:Node=self) -> Node:
	if TARGET_GROUPS.any(n.is_in_group): return n
	if TARGET_META.any(n.has_meta): return n
	if n == get_tree().current_scene:
		printerr("could not find any parent member of ", TARGET_GROUPS)
		return null
	if not n.get_parent():
		printerr("could not find any parent member of ", TARGET_GROUPS)
		return null
	return find_closeable_parent(n.get_parent())

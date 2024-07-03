class_name Zaft_Closer_Button extends Button

@export var target : Node

const TARGET_GROUPS = [
  "popup",
  "sub-menu",
  "closeable",
]

const TARGET_ACTIONS = [
  "menu-close",
  "menu-back",
]

func _ready() -> void:
  text = "Close"
  if not target: target = find_closeable_parent()
  pressed.connect(close_target)

func close_target():
  if target:
    target.queue_free()

func _input(event: InputEvent) -> void:
  if TARGET_ACTIONS.any(event.is_action_pressed):
    get_viewport().set_input_as_handled()
    close_target()

func find_closeable_parent(n:Node=self) -> Node:
  if TARGET_GROUPS.any(n.is_in_group): return n
  if n == get_tree().current_scene:
    printerr("could not find any parent member of ", TARGET_GROUPS)
    return null
  if not n.get_parent():
    printerr("could not find any parent member of ", TARGET_GROUPS)
    return null
  return find_closeable_parent(n.get_parent())

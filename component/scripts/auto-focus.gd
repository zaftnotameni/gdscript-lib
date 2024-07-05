class_name Zaft_AutoFocus extends Zaft_ComponentBase

@onready var control : Control = target_node

func _ready() -> void:
  process_using = PROCESS_USING.None
  super()
  await get_tree().create_timer(0.02).timeout
  control.grab_focus.call_deferred()

class_name Z_TimerUISceneController extends Node

func _ready() -> void:
  Z_ControlUtil.control_set_top_right_min_size.call_deferred(owner)


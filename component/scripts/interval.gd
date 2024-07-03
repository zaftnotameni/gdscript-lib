class_name Zaft_Interval extends Zaft_ComponentBase

## method called on the target node each time the interval is elapsed
@export var method_on_interval: StringName
@export var interval_in_seconds := 5.0

var elapsed := 0.0

func reset():
  elapsed = 0.0

func component_process(delta:float):
  if interval_in_seconds <= 0: return
  elapsed += delta
  if elapsed > interval_in_seconds:
    reset()
    if target_node:
      if method_on_interval and not method_on_interval.is_empty():
        target_node.call(method_on_interval)
      elif target_node and target_node.has_method(&'on_interval'):
        target_node.on_interval()
      else:
        target_node.queue_free()


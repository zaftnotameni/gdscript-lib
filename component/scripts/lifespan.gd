class_name Z_Lifespan extends Z_ComponentBase

## method called on the target node when the lifespan is elapsed
@export var method_when_lifespent : StringName
## -1 for infinite
@export var lifespan := 5.0

var elapsed := 0.0

func reset():
  elapsed = 0.0

func component_process(delta:float):
  if lifespan <= 0: return
  elapsed += delta
  if elapsed > lifespan:
    reset()
    if target_node:
      if method_when_lifespent and not method_when_lifespent.is_empty():
        target_node.call(method_when_lifespent)
      elif target_node and target_node.has_method(&'on_lifespan_elapsed'):
        target_node.on_lifespan_elapsed()
      else:
        target_node.queue_free()


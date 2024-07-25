class_name Z_Velocity extends Z_ComponentBase

@export var linear_velocity : float = 10.0
@export var direction := Vector2.ZERO

func component_process(delta:float):
  target_node.position += direction * linear_velocity * delta

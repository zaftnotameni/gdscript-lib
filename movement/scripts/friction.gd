class_name Zaft_Movement_Friction extends Resource

static func apply_lerpstop_to(_velocity:Vector2,_lerp:float,_delta:float) -> Vector2:
  if not is_zero_approx(_velocity.x):
    _velocity.x = lerp(_velocity.x, 0.0, min(1.0, _delta * _lerp))
  if is_zero_approx(_velocity.x):
    _velocity.x = 0.0
  return _velocity

static func apply_friction_to(_velocity:Vector2,_friction:float,_delta:float) -> Vector2:
  if not is_zero_approx(_velocity.x):
    var new_x := _velocity.x - (_friction * _delta * signf(_velocity.x))
    if sign(new_x) != sign(_velocity.x):
      _velocity.x = 0.0
    else:
      _velocity.x = new_x
  if is_zero_approx(_velocity.x):
    _velocity.x = 0.0
  return _velocity

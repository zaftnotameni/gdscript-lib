class_name Z_Movement_Gravity extends Resource

static func apply_lerpfall_to(_velocity:Vector2,_max:float,_lerp:float,_delta:float) -> Vector2:
  _velocity.y = lerp(_velocity.y, _max, min(1.0, _delta * _lerp))
  return _velocity

static func apply_gravity_to(_velocity:Vector2,_gravity:float,_delta:float) -> Vector2:
  _velocity.y = _velocity.y + (_gravity * _delta)
  return _velocity

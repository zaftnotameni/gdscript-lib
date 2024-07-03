class_name Zaft_Movement_Acceleration extends Resource

static func apply_lerpmax_to(_velocity:Vector2,_max:float,_lerp:float,_delta:float) -> Vector2:
  _velocity.x = lerp(_velocity.x, _max * sign(_velocity.x), min(1.0, _delta * _lerp))
  return _velocity

static func apply_acceleration_to(_velocity:Vector2,_acceleration:float,_delta:float) -> Vector2:
  _velocity.x = _velocity.x + (_acceleration * _delta)
  return _velocity

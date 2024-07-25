class_name Z_SimpleDamageReceiver extends Node

@export var health := 0

signal sig_take(data:Z_Hit_Data)
signal sig_died(data:Z_Hit_Data)

func take_damage(data:Z_Hit_Data):
  if not data: return
  if data.handled: return
  data.health = health
  prints(data.dealer, data.receiver)
  if data.dealer and 'damage' in data.dealer:
    health -= data.dealer.damage
    data.health = health
    data.handled = true
    sig_take.emit(data)
    if health < 0:
      sig_died.emit(data)
  elif data.target and 'damage' in data.target:
    health -= data.target.damage
    data.health = health
    data.handled = true
    sig_take.emit(data)
    if health < 0:
      sig_died.emit(data)

func _to_string() -> String:
  return "%s(health: %s)" % [get_path(), health]

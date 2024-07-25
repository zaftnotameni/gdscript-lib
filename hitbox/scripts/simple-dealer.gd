class_name Z_SimpleDamageDealer extends Node

@export var damage := 0

signal sig_died(data:Z_Hit_Data)
signal sig_deal(data:Z_Hit_Data)

func deal_damage(data:Z_Hit_Data):
  if not data: return
  if data.handled: return
  data.damage = damage
  prints(data.dealer.get_path(), data.receiver.get_path())
  if data.receiver and 'health' in data.receiver:
    data.receiver.health -= damage
    data.handled = true
    sig_deal.emit(data)
    if data.receiver.health < 0:
      sig_died.emit(data)
  elif data.target and 'health' in data.target:
    data.target.health -= damage
    data.handled = true
    sig_deal.emit(data)
    if data.target.health < 0:
      sig_died.emit(data)

func _to_string() -> String:
  return "%s(damage: %s)" % [get_path(), damage]

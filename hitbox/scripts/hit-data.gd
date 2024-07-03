class_name Zaft_Hit_Data extends RefCounted

enum HIT_DATA_MODE { Invalid = 0, Take, Deal }

const TAKE := &'take_damage'
const DEAL := &'deal_damage'

var damage : int
var health : int
var dealer : Node
var taker : Node
var source : Area2D
var target : Node
var mode : HIT_DATA_MODE = HIT_DATA_MODE.Invalid
var handled := false

func mark_as_handled(_h:=true) -> Zaft_Hit_Data:
  handled = _h
  return self

func apply_take_damage():
  if not handled and source and 'health' in source:
    health = source.get('health')

  if not handled and target and 'damage' in target:
    damage = target.get('damage')

  if not handled and taker and taker.has_method(TAKE):
    taker.invoke(TAKE, self)

  if not handled and source and 'health' in source and target and 'damage' in target:
    source.health -= target.damage

func apply_deal_damage():
  if not handled and source and 'damage' in source:
    damage = source.get('damage')

  if not handled and target and 'health' in target:
    health = target.get('health')

  if not handled and dealer and dealer.has_method(DEAL):
    dealer.invoke(DEAL, self)

  if not handled and target and 'health' in target and source and 'damage' in source:
    target.health -= source.damage

func _to_string() -> String:
  return "\
    mode: %s\n\
    damage: %s\n\
    health: %s\n\
    handled: %s\n\
    dealer: %s\n\
    taker: %s\n\
    source: %s\n\
    target: %s\n\
    " % [HIT_DATA_MODE.find_key(mode), damage, health, handled, dealer, taker, source, target]

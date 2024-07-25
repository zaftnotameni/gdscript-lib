class_name Z_Hitbox_Node extends Area2D

enum MODE { None = 0, DealDamage = 1, TakeDamage = 2 }

@export var hitbox_mode : MODE
@export var damage_dealer : Node
@export var damage_taker : Node
@export var invincible : bool
@export var health : int = 10
@export var damage : int = 1

signal sig_take_damage(data:Z_Hit_Data)
signal sig_ignore_damage_invincible(data:Z_Hit_Data)
signal sig_deal_damage(data:Z_Hit_Data)
signal sig_died(data:Z_Hit_Data)

func create_hit_data(b:Node) -> Z_Hit_Data:
  var data := Z_Hit_Data.new()
  data.target = b
  data.source = self
  data.dealer = damage_dealer
  data.taker = damage_taker
  return data

func handle_deal_damage(b:Node):
  var data := create_hit_data(b)
  if 'damage_taker' in b:
    data.taker = b.damage_taker
  data.apply_deal_damage()
  sig_deal_damage.emit(data)

func handle_take_damage(b:Node):
  var data := create_hit_data(b)
  if 'damage_dealer' in b:
    data.dealer = b.damage_dealer
  if invincible:
    sig_ignore_damage_invincible.emit(data)
    return
  data.apply_take_damage()
  sig_take_damage.emit(data)
  if health <= 0:
    sig_died.emit(data)

func _ready() -> void:
  body_entered.connect(on_body_entered)
  area_entered.connect(on_area_entered)
  assert(not damage_dealer or damage_dealer.has_method(&'deal_damage'), '%s damage_dealer must have a deal_damage method' % get_path())
  assert(not damage_taker or damage_taker.has_method(&'take_damage'), '%s damage_taker must have a take_damage method' % get_path())

func on_any_entered(b:Node):
  match hitbox_mode:
    MODE.DealDamage:
      handle_deal_damage(b)
    MODE.TakeDamage:
      handle_take_damage(b)

func on_area_entered(b:Area2D):
  on_any_entered(b)

func on_body_entered(b:Node):
  on_any_entered(b)

func _to_string() -> String:
  return "%s\n[hitbox_mode:%s][health:%s][damage:%s][dealer:%s][taker:%s]" % [
    get_path(),
    MODE.find_key(hitbox_mode),
    health,
    damage,
    str(damage_dealer.get_path()) if damage_dealer else 'null',
    str(damage_taker.get_path()) if damage_taker else 'null',
  ]

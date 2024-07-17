class_name Zaft_PlayerGravityBasedOrientation extends Area2D

@onready var player : Zaft_PlayerCharacter = owner
@export var body : Zaft_PlayerBody
@export var windrose : Zaft_PlayerWindrose
@export var gravity_source : Zaft_GravityWell

func _ready() -> void:
  if not windrose: windrose = Zaft_ComponentBase.resolve_from(player, Zaft_PlayerWindrose)
  if not body: body = Zaft_ComponentBase.resolve_at(player, Zaft_PlayerBody)
  add_child(body.duplicate())

func _physics_process(_delta: float) -> void:
  on_gravity_source_updated()

func apply_gravity(new_gravity_source:Zaft_GravityWell):
  update_gravity_source(new_gravity_source)

func update_gravity_source(new_gravity_source:Zaft_GravityWell):
  gravity_source = new_gravity_source
  on_gravity_source_updated()

func on_gravity_source_updated():
  player.up_direction = -player.global_position.direction_to(gravity_source.global_position)
  player.rotation = Vector2.UP.angle_to(player.up_direction)

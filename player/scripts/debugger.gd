class_name Zaft_PlayerDebugger extends Node2D

@export_range(1, 60) var fps : int = 8
@export var debug_right : bool = false
@export var debug_down : bool = false
@export var debug_velocity : bool = false
@export var debug_max_velocity : bool = false
@export var debug_normal: bool = false
@export var debug_gravity: bool = false
@export var debug_machine: bool = false

@onready var player : Zaft_PlayerCharacter = owner

func resolve_gravity() -> Zaft_PlayerGravityBasedOrientation: return Zaft_ComponentBase.resolve_from(player, Zaft_PlayerGravityBasedOrientation)
func resolve_windrose() -> Zaft_PlayerWindrose: return Zaft_ComponentBase.resolve_from(player, Zaft_PlayerWindrose)
func resolve_stats() -> Zaft_PlayerStats: return Zaft_ComponentBase.resolve_from(player, Zaft_PlayerStats)
func resolve_machine() -> Zaft_PlayerStateMachine: return Zaft_ComponentBase.resolve_from(player, Zaft_PlayerStateMachine)


@onready var lbl_machine := Label.new()

func on_machine_state_change(curr:Zaft_PlayerStateMachineState,prev:Zaft_PlayerStateMachineState):
  lbl_machine.text = '[%s]=%s>[%s]=%s>[%s]' % [prev.via_state, prev.via_transition, prev.name, curr.via_transition, curr.name]
  Zaft_Autoload_Util.control_set_bottom_right_min_size(lbl_machine)

func _ready() -> void:
  if debug_machine:
    lbl_machine.text = 'Player State Machine Debug'
    __zaft.layer.debug.add_child(lbl_machine)
    Zaft_Autoload_Util.control_set_bottom_right_min_size(lbl_machine)
    resolve_machine().sig_state_did_transition.connect(on_machine_state_change)

func _draw() -> void:
  if debug_right:
    draw_line(Vector2.ZERO, resolve_windrose().right() * LEN_RIGHT, COLOR_RIGHT, WID_RIGHT)
  if debug_down:
    draw_line(Vector2.ZERO, resolve_windrose().down() * LEN_DOWN, COLOR_DOWN, WID_DOWN)
  if debug_velocity:
    draw_line(Vector2.ZERO, player.velocity, COLOR_SPEED, WID_SPEED)
  if debug_max_velocity:
    draw_line(Vector2.ZERO, player.velocity.normalized() * player.stats.max_speed_from_input, COLOR_MAX_SPEED, WID_MAX_SPEED)
  if debug_gravity:
    if resolve_gravity() and resolve_gravity().gravity_source:
      draw_line(Vector2.ZERO, to_local(resolve_gravity().gravity_source.global_position), COLOR_GRAVITY, WID_GRAVITY)

func _process(delta: float) -> void:
  elapsed += delta
  if elapsed > (1.0/fps):
    if debug_right or debug_down or debug_velocity or debug_down or debug_max_velocity or debug_normal:
      queue_redraw()
      elapsed = 0.0

var elapsed : float = 0
const WID_DOWN := 6
const WID_RIGHT := 6
const WID_MAX_SPEED := 4
const WID_SPEED := 2
const WID_GRAVITY := 2
const LEN_DOWN := 64
const LEN_RIGHT := 64
const COLOR_DOWN := Color.GREEN
const COLOR_RIGHT := Color.BLUE
const COLOR_MAX_SPEED := Color.TEAL
const COLOR_SPEED := Color.CYAN
const COLOR_GRAVITY := Color.PINK

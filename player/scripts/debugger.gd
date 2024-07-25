class_name Z_PlayerDebugger extends Node2D

@export_range(1, 60) var fps : int = 8
@export var debug_right : bool = false
@export var debug_down : bool = false
@export var debug_velocity : bool = false
@export var debug_max_velocity : bool = false
@export var debug_normal: bool = false
@export var debug_gravity: bool = false
@export var debug_machine: bool = false

@onready var player : Z_PlayerCharacter = owner

func resolve_gravity() -> Z_PlayerGravityBasedOrientation: return Z_ComponentBase.resolve_from(player, Z_PlayerGravityBasedOrientation)
func resolve_windrose() -> Z_PlayerWindrose: return Z_ComponentBase.resolve_from(player, Z_PlayerWindrose)
func resolve_stats() -> Z_PlayerStats: return Z_ComponentBase.resolve_from(player, Z_PlayerStats)
func resolve_machine() -> Z_PlayerStateMachine: return Z_ComponentBase.resolve_from(player, Z_PlayerStateMachine)


@onready var lbl_machine := Label.new()

func on_machine_state_change(curr:Z_PlayerStateMachineState,prev:Z_PlayerStateMachineState):
  lbl_machine.text = '[%s]=%s>[%s]=%s>[%s]' % [prev.via_state, prev.via_transition, prev.name, curr.via_transition, curr.name]
  Z_Autoload_Util.control_set_bottom_right_min_size(lbl_machine)

func _ready() -> void:
  if debug_machine:
    lbl_machine.text = 'Player State Machine Debug'
    __zaft.layer.debug.add_child(lbl_machine)
    Z_Autoload_Util.control_set_bottom_right_min_size(lbl_machine)
    resolve_machine().sig_state_did_transition.connect(on_machine_state_change)

func _draw() -> void:
  if debug_right:
    draw_line(Vector2.ZERO, Vector2.RIGHT * LEN_RIGHT, COLOR_RIGHT, WID_RIGHT)
  if debug_down:
    draw_line(Vector2.ZERO, Vector2.DOWN * LEN_DOWN, COLOR_DOWN, WID_DOWN)
  if debug_max_velocity:
    draw_line(Vector2.ZERO, player.velocity.normalized().rotated(-player.rotation) * player.stats.max_speed_from_input, COLOR_MAX_SPEED, WID_MAX_SPEED)
  if debug_velocity:
    draw_line(Vector2.ZERO, player.velocity.rotated(-player.rotation), COLOR_SPEED, WID_SPEED)
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

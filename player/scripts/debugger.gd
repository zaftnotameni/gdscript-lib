class_name Z_PlayerDebugger extends Node2D

@export_range(1, 60) var fps : int = 8
@export var debug_velocity : bool = false
@export var debug_max_velocity : bool = false
@export var debug_machine: bool = false

@onready var player : Z_PlayerCharacter = owner

func resolve_windrose() -> Z_PlayerWindrose: return Z_ComponentBase.resolve_from(player, Z_PlayerWindrose)
func resolve_stats() -> Z_PlayerStats: return Z_ComponentBase.resolve_from(player, Z_PlayerStats)
func resolve_machine() -> Z_PlayerStateMachine: return Z_ComponentBase.resolve_from(player, Z_PlayerStateMachine)

var lbl_machine : Label

func lazy_lbl_machine() -> Label:
  if not lbl_machine:
    var existing := __zaft.layer.debug.get_node_or_null('LabelPlayerStateMachineDebug') as Label
    lbl_machine = existing if existing else Label.new()
    lbl_machine.name = 'LabelPlayerStateMachineDebug'
    lbl_machine.text = 'Player State Machine Debug'
    if not existing: __zaft.layer.debug.add_child(lbl_machine)
  return lbl_machine

func on_machine_state_change(curr:Z_PlayerStateMachineState,prev:Z_PlayerStateMachineState):
  lazy_lbl_machine().text = '[%s]=%s>[%s]=%s>[%s]' % [prev.via_state, prev.via_transition, prev.name, curr.via_transition, curr.name]
  Z_Autoload_Util.control_set_bottom_right_min_size(lazy_lbl_machine())

func _exit_tree() -> void:
  if lbl_machine and lbl_machine.is_inside_tree() and not lbl_machine.is_queued_for_deletion():
    lbl_machine.queue_free()
    lbl_machine = null

func _ready() -> void:
  if debug_machine:
    Z_Autoload_Util.control_set_bottom_right_min_size(lazy_lbl_machine())
    resolve_machine().sig_state_did_transition.connect(on_machine_state_change)

func _draw() -> void:
  if debug_max_velocity:
    draw_line(Vector2.ZERO, player.velocity.normalized().rotated(-player.rotation) * player.stats.max_speed_from_input, COLOR_MAX_SPEED, WID_MAX_SPEED)
  if debug_velocity:
    draw_line(Vector2.ZERO, player.velocity.rotated(-player.rotation), COLOR_SPEED, WID_SPEED)

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

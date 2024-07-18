class_name Zaft_PlayerStats extends Node

enum FACING { Right, Left }

signal sig_energy_changed()
signal sig_fuel_changed()
signal sig_energy_rejected()
signal sig_fuel_rejected()

func setter(thing:StringName, v:Variant):
  if is_equal_approx(get(thing), v): return true
  if v >= 0:
    set(thing, v)
    emit_signal(&'sig_%s_changed' % thing)
    return true
  else:
    emit_signal(&'sig_%s_rejected' % thing)
    return false

func setter_rel(thing:StringName, v:Variant):
  if is_zero_approx(v): return true
  return setter(thing, get(thing) + v)

func update_fuel(v): return setter(&'fuel', v)
func update_energy(v): return setter(&'energy', v)
func update_fuel_rel(v): return setter_rel(&'fuel', v)
func update_energy_rel(v): return setter_rel(&'energy', v)

## in %
@export var energy : float = 100
## in %
@export var fuel : float = 100

## in %/use
@export var fuel_cons_dash_air: float = 5
## in %/use
@export var fuel_cons_dash_gnd: float = 10

## in %/sec
@export var energy_sol_gain : float = 1
## in %/sec
@export var energy_ion_cons : float = 1
## in %/sec
@export var energy_mine_cons : float = 1
## in %/sec
@export var fuel_cons_jetpack : float = 1

# directions
@export var facing : FACING

## in pixels
@export var player_width : int = 24
## in pixels
@export var player_height : int = 64

## in secs
@export var dash_duration : float = 0.1
## in secs
@export var coyote_duration : float = 0.1

## in pixels/sec
@export var max_speed_from_input : int = player_width * 10
## in pixels/sec
@export var initial_speed_from_input : int = max_speed_from_input
## in pixels/sec
@export var dash_initial_speed : int = max_speed_from_input * 4

## in pixels/sec/sec
@export var acceleration_from_input : int = 128
## in pixels/sec/sec
@export var decceleration_from_lack_of_input : int = 2048

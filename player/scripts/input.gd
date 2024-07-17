class_name Zaft_PlayerInput extends Node

const PLAYER_INPUT_UP := &"player-up"
const PLAYER_INPUT_DOWN := &"player-down" 
const PLAYER_INPUT_LEFT := &"player-left"
const PLAYER_INPUT_RIGHT := &"player-right"
const PLAYER_INPUT_JUMP := &"player-jump"
const PLAYER_INPUT_DASH := &"player-dash"
const PLAYER_INPUT_ROLL := &"player-roll"
const PLAYER_INPUT_DODGE := &"player-dodge"
const PLAYER_INPUT_ATTACK := &"player-attack"
const PLAYER_INPUT_MINE := &"player-mine"
const PLAYER_INPUT_PLACE := &"player-place"

static func input_x(a:=&"player-left",d:=&"player-right")->float:
  return Input.get_axis(a,d)

static func input_y(w:=&"player-up",s:=&"player-down")->float:
  return Input.get_axis(w,s)

static func input_ad_scalar(a:=PLAYER_INPUT_LEFT,d:=PLAYER_INPUT_RIGHT)->float:
  return Input.get_axis(a,d)

static func input_wasd(w:=&"player-up",a:=&"player-left",s:=&"player-down",d:=&"player-right")->Vector2:
  return Input.get_vector(a,d,w,s)

static func input_wasd_not_normalized(w:=&"player-up",a:=&"player-left",s:=&"player-down",d:=&"player-right")->Vector2:
  return Vector2(Input.get_axis(a,d),Input.get_axis(w,s))

static func y_only(v:Vector2)->Vector2:return Vector2(0.0, v.y)
static func x_only(v:Vector2)->Vector2:return Vector2(v.x, 0.0)

static func y_shadow(v:Vector2)->float:return v.dot(Vector2.DOWN)
static func x_shadow(v:Vector2)->float:return v.dot(Vector2.RIGHT)

static func event_is_jump_just_pressed(event:InputEvent) -> bool:
  return event.is_action_pressed(PLAYER_INPUT_JUMP)

static func event_is_jump_pressed(event:InputEvent) -> bool:
  return event.is_action_pressed(PLAYER_INPUT_JUMP, true)

static func event_is_jump_released(event:InputEvent) -> bool:
  return event.is_action_released(PLAYER_INPUT_JUMP)

static func event_is_attack_just_pressed(event:InputEvent) -> bool:
  return event.is_action_pressed(PLAYER_INPUT_ATTACK)

static func event_is_attack_pressed(event:InputEvent) -> bool:
  return event.is_action_pressed(PLAYER_INPUT_ATTACK, true)

static func event_is_attack_released(event:InputEvent) -> bool:
  return event.is_action_released(PLAYER_INPUT_ATTACK)

static func event_is_dash_just_pressed(event:InputEvent) -> bool:
  return event.is_action_pressed(PLAYER_INPUT_DASH)

static func event_is_dash_pressed(event:InputEvent) -> bool:
  return event.is_action_pressed(PLAYER_INPUT_DASH, true)

static func event_is_dash_released(event:InputEvent) -> bool:
  return event.is_action_released(PLAYER_INPUT_DASH)

static func event_is_roll_just_pressed(event:InputEvent) -> bool:
  return event.is_action_pressed(PLAYER_INPUT_ROLL)

static func event_is_roll_pressed(event:InputEvent) -> bool:
  return event.is_action_pressed(PLAYER_INPUT_ROLL, true)

static func event_is_roll_released(event:InputEvent) -> bool:
  return event.is_action_released(PLAYER_INPUT_ROLL)

static func event_is_dodge_just_pressed(event:InputEvent) -> bool:
  return event.is_action_pressed(PLAYER_INPUT_DODGE)

static func event_is_dodge_pressed(event:InputEvent) -> bool:
  return event.is_action_pressed(PLAYER_INPUT_DODGE, true)

static func event_is_dodge_released(event:InputEvent) -> bool:
  return event.is_action_released(PLAYER_INPUT_DODGE)

static func event_is_place_just_pressed(event:InputEvent) -> bool:
  return event.is_action_pressed(PLAYER_INPUT_PLACE)

static func event_is_place_pressed(event:InputEvent) -> bool:
  return event.is_action_pressed(PLAYER_INPUT_PLACE, true)

static func event_is_place_released(event:InputEvent) -> bool:
  return event.is_action_released(PLAYER_INPUT_PLACE)

static func event_is_mine_just_pressed(event:InputEvent) -> bool:
  return event.is_action_pressed(PLAYER_INPUT_MINE)

static func event_is_mine_pressed(event:InputEvent) -> bool:
  return event.is_action_pressed(PLAYER_INPUT_MINE, true)

static func event_is_mine_released(event:InputEvent) -> bool:
  return event.is_action_released(PLAYER_INPUT_MINE)

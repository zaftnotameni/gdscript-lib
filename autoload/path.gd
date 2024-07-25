class_name Z_Autoload_Path extends Node

const PLAYER_CHARACTER_STATE_MACHINE_GROUP := &'player-character-state-machine'
const PLAYER_CHARACTER_GROUP := &'player-character'
const MAIN_CAMERA_GROUP := &'main-camera'
const STOPWATCH_GROUP := &'stopwatch'
const LEADERBOARD_GROUP := &'leaderboard'
const MAIN_CAMERA_PARALLAX_GROUP := &'main-camera-parallax'
const MENU_PAUSE := &'menu-pause'

static func group_all_nodes(g:StringName=&"Group Name") -> Array[Node]:
  return Z_Autoload_Util.scene_tree().get_nodes_in_group(g)

static func group_only_node(g:StringName=&"Group Name") -> Node:
  var nodes := group_all_nodes(g)
  var count := nodes.size()
  assert(count == 1, "must have only one element in group %s, got %s" % [g, count])
  return nodes.front()

static func group_maybe_node(g:StringName=&"Group Name") -> Node:
  return group_all_nodes(g).front()

static func first_node(g:StringName=&"Group Name") -> Node:
  var node := group_maybe_node(g)
  assert(node, "must have at least one element in group %s" % g)
  return node

static func group_main_camera_only_node(g:=MAIN_CAMERA_GROUP) -> Camera2D:
  return group_only_node(g)

static func group_player_character_only_node(g:=PLAYER_CHARACTER_GROUP) -> CharacterBody2D:
  return group_only_node(g)

static func group_player_character_state_machine_only_node(g:=PLAYER_CHARACTER_STATE_MACHINE_GROUP) -> Z_StateMachine:
  return group_only_node(g)

static func group_stopwatch_only_node(g:=STOPWATCH_GROUP) -> Z_Stopwatch:
  return group_only_node(g)

static func group_leaderboard_only_node(g:=LEADERBOARD_GROUP) -> Z_LeaderboardApi:
  return group_only_node(g)

static func await_for_ready(n:Node) -> Node:
  if n:
    if n.is_node_ready(): return n
    else:
      await n.ready
      return n
  else: return n

static func await_for_first_node_in_group(g:=PLAYER_CHARACTER_GROUP,max_attempts:=10) -> Node:
  var n := group_maybe_node(g)
  if n: return await await_for_ready(n)
  await Z_Autoload_Util.scene_tree().process_frame
  return await await_for_ready(await await_for_first_node_in_group(g,max_attempts-1))


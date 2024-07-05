class_name Zaft_Autoload_Path extends Node

const PLAYER_CHARACTER_STATE_MACHINE_GROUP := &'player-character-state-machine'
const PLAYER_CHARACTER_GROUP := &'player-character'
const MAIN_CAMERA_GROUP := &'main-camera'
const MAIN_CAMERA_PARALLAX_GROUP := &'main-camera-parallax'

var for_group := ForGroup.new(self)
class ForGroup:
  var its : Node
  func _init(_its:Node) -> void: its = _its

  func all_nodes(g:String="Group Name") -> Array[Node]:
    return its.get_tree().get_nodes_in_group(g)

  func only_node(g:String="Group Name") -> Node:
    var nodes := all_nodes(g)
    var count := nodes.size()
    assert(count == 1, "must have only one element in group %s, got %s" % [g, count])
    return nodes.front()

  func maybe_node(g:String="Group Name") -> Node:
    return all_nodes(g).front()

  func first_node(g:String="Group Name") -> Node:
    var node := maybe_node(g)
    assert(node, "must have at least one element in group %s" % g)
    return node

  func main_camera(g:=MAIN_CAMERA_GROUP) -> Camera2D:
    return only_node(g)

  func player_character(g:=PLAYER_CHARACTER_GROUP) -> CharacterBody2D:
    return only_node(g)

  func player_character_state_machine(g:=PLAYER_CHARACTER_STATE_MACHINE_GROUP) -> Zaft_StateMachine:
    return only_node(g)

class_name Z_MenuTransitionUtil extends Node

static func resolve_container(node:Node):
	if node is CanvasLayer:
		return node
	if node == Z_TreeUtil.current_scene():
		push_error('could not find container, make sure the hierarchy includes a CanvasLayer %s' % node.get_path())
		return node
	return resolve_container(node.get_parent())

## source_button: the button the triggers the menu sliding down
##
## target_menu: an instance (not yet in the tree) of the menu to be shown
##
## container (optional): where the menu will be shown, defaults to the first CanvasLayer up the tree, or the current scene root
static func menu_slide_down_in(source_button:BaseButton, target_menu:Node, container:Node=null) -> Tween:
	if not Z_State.in_ready(): return

	# store the current pause state and pause the game
	var was_paused := Z_TreeUtil.scene_tree().paused
	Z_TreeUtil.scene_tree().paused = true

	# store current state an mark game as in menu transition
	var current_state := Z_State.game_state
	Z_State.menu_transition()

	# find an adequate container
	if not container: container = resolve_container(source_button)

	# prepare the target menu
	Z_ControlUtil.control_set_full_rect(target_menu)
	target_menu.position.y = -Z_Config.screen_height

	# restore focus and game state when the target menu is closed
	target_menu.tree_exited.connect(source_button.grab_focus)
	target_menu.tree_exited.connect(Z_State.set_game_state.bind(current_state))

	# add to tree and awaits for it to be ready
	container.add_child.call_deferred(target_menu)
	await target_menu.ready

	# animate it in and mark game as in a menu state
	var tween := Z_TweenUtil.tween_ignores_pause(Z_TweenUtil.tween_fresh_eased_in_out_cubic())
	tween.tween_property(target_menu, ^'position:y', 0, 0.3)
	tween.tween_property(Z_TreeUtil.scene_tree(), ^'paused', was_paused, 0.0)
	tween.tween_callback(Z_State.menu)
	return tween

## source_button: the button the triggers the menu sliding up (close button)
##
## target_menu: an instance (already in the tree) of the menu to be disposed of
static func menu_slide_up_out(target_menu:Node, acceptable_states:Dictionary={}) -> Tween:
	if (not acceptable_states or acceptable_states.is_empty()) and not Z_State.in_ready(): return
	if not acceptable_states: return
	if not acceptable_states.get_or_add(Z_State.game_state, false): return

	# store the current pause state and pause the game
	var was_paused := Z_TreeUtil.scene_tree().paused
	Z_TreeUtil.scene_tree().paused = true

	# store the current game state and mark the game as in menu transition
	var current_game_state := Z_State.game_state
	Z_State.menu_transition()

	target_menu.position.y = 0

	# animate it in and mark game as in a menu state
	var tween := Z_TweenUtil.tween_ignores_pause(Z_TweenUtil.tween_fresh_eased_in_out_cubic())
	tween.tween_property(target_menu, ^'position:y', -Z_Config.screen_height, 0.3)
	tween.tween_callback(target_menu.queue_free)
	tween.tween_property(Z_TreeUtil.scene_tree(), ^'paused', was_paused, 0.0)
	tween.tween_property(Z_State, ^'game_state', current_game_state, 0.0)
	return tween

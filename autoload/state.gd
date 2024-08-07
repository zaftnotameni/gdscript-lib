class_name Z_State extends Node

enum GAME_STATE { Initial, Loading, Title, Menu, MenuTransition, Transition, Game, SceneTransitionInGame, PlayerDying, Paused }

static var game_state := GAME_STATE.Initial : set = set_game_state

static func in_transition(): return [
	GAME_STATE.Transition,
	GAME_STATE.MenuTransition,
	GAME_STATE.SceneTransitionInGame,
	GAME_STATE.PlayerDying,
	GAME_STATE.Loading,
].has(game_state)

static func in_ready(): return [
	GAME_STATE.Game,
	GAME_STATE.Title,
	GAME_STATE.Menu,
].has(game_state)

static func initial(): game_state = GAME_STATE.Initial
static func loading(): game_state = GAME_STATE.Loading
static func title(): game_state = GAME_STATE.Title
static func menu(): game_state = GAME_STATE.Menu
static func transition(): game_state = GAME_STATE.Transition
static func menu_transition(): game_state = GAME_STATE.MenuTransition
static func game(): game_state = GAME_STATE.Game
static func paused(): game_state = GAME_STATE.Paused

static func mark_as_scene_transition_in_game():
	__z.state.game_state = __z.state.GAME_STATE.SceneTransitionInGame

static func is_dying() -> bool:
	return __z.state.game_state == __z.state.GAME_STATE.PlayerDying

static func mark_as_dying():
	__z.state.game_state = __z.state.GAME_STATE.PlayerDying

static func is_game() -> bool:
	return __z.state.game_state == __z.state.GAME_STATE.Game

static func mark_as_game():
	__z.state.game_state = __z.state.GAME_STATE.Game

static func set_game_state(v):
	if v == game_state: return
	var prev = game_state
	game_state = v
	print_verbose('%s => %s' % [GAME_STATE.find_key(prev), GAME_STATE.find_key(v)])
	__z.bus.sig_game_state_changed.emit(v,prev)

func close_pause_menu() -> Tween:
	var n := get_tree().get_first_node_in_group(Z_Path.MENU_PAUSE)
	if not n: return
	return Z_MenuTransitionUtil.menu_slide_up_out(n, {
		Z_State.GAME_STATE.Paused: true,
		Z_State.GAME_STATE.Menu: true,
	})

func show_pause_menu():
	if not Z_Config.scene_menu_pause:
		push_error('missing configuration Z_Config.scene_menu_pause')
		return false
	var n := Z_Config.scene_menu_pause.instantiate()
	n.process_mode = Node.PROCESS_MODE_ALWAYS
	__z.layer.menu.add_child(n)
	n.add_to_group(Z_Path.MENU_PAUSE)
	var t := Z_TweenUtil.tween_fresh_eased_in_out_cubic()
	t.set_pause_mode(Tween.TweenPauseMode.TWEEN_PAUSE_PROCESS)
	t.tween_property(n, ^'position:y', 0, 0.2).from(1600)
	await t.finished
	return true

func on_quit_to_title() -> bool:
	if game_state != GAME_STATE.Paused: return false
	get_viewport().set_input_as_handled()
	if not Z_Config.scene_menu_title:
		push_error('missing configuration Z_Config.scene_menu_title')
		return false
	var n := Z_Config.scene_menu_title.instantiate()
	n.process_mode = Node.PROCESS_MODE_ALWAYS
	__z.layer.wipe_all_managed()
	await get_tree().process_frame
	__z.layer.menu.add_child(n)
	var t := Z_TweenUtil.tween_fresh_eased_in_out_cubic()
	t.set_pause_mode(Tween.TweenPauseMode.TWEEN_PAUSE_PROCESS)
	t.tween_property(n, ^'position:y', 0, 0.2).from(1600)
	await t.finished
	return true

func on_pause() -> bool:
	if game_state != GAME_STATE.Game: return false
	get_viewport().set_input_as_handled()
	paused()
	get_tree().paused = true
	await show_pause_menu()
	return true

func on_unpause() -> bool:
	if game_state != GAME_STATE.Paused: return false
	get_viewport().set_input_as_handled()
	var t := close_pause_menu()
	await t.finished
	game()
	get_tree().paused = false
	return true

func on_back() -> bool:
	if game_state == GAME_STATE.Paused: return await on_unpause()
	get_viewport().set_input_as_handled()
	return true

func _unhandled_input(event: InputEvent) -> void:
	if Z_Config.is_event_pause_pressed(event): if await on_pause(): return
	if Z_Config.is_event_unpause_pressed(event): if await on_unpause(): return
	if Z_Config.is_event_back_pressed(event): if await on_back(): return

func _enter_tree() -> void:
	process_mode = ProcessMode.PROCESS_MODE_ALWAYS

func _ready() -> void:
	__z.bus.sig_unpause_requested.connect(on_unpause)
	__z.bus.sig_quit_to_title_requested.connect(on_quit_to_title)

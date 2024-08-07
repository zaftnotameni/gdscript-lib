class_name Z_InputSetup extends RefCounted

enum InputActionName {
	PAUSE,
	UNPAUSE,
	MENU_CLOSE,
	MENU_ACCEPT,
	MENU_BACK,
	PLAYER_UP,
	PLAYER_DOWN,
	PLAYER_LEFT,
	PLAYER_RIGHT,
	PLAYER_JUMP,
	PLAYER_DASH,
	PLAYER_ROLL,
	PLAYER_ATTACK,
}

static func initialize_input():
	var all_inputs := {
		InputActionName.PLAYER_RIGHT: [k(KEY_D), k(KEY_RIGHT), b(JOY_BUTTON_DPAD_RIGHT), a(JOY_AXIS_LEFT_X, 1.0)],
		InputActionName.PLAYER_LEFT: [k(KEY_A), k(KEY_LEFT), b(JOY_BUTTON_DPAD_LEFT), a(JOY_AXIS_LEFT_X, -1.0)],
		InputActionName.PLAYER_DOWN: [k(KEY_S), k(KEY_DOWN), b(JOY_BUTTON_DPAD_DOWN), a(JOY_AXIS_LEFT_Y, 1.0)],
		InputActionName.PLAYER_UP: [k(KEY_W), k(KEY_UP), b(JOY_BUTTON_DPAD_UP), a(JOY_AXIS_LEFT_Y, -1.0)],
		InputActionName.MENU_ACCEPT: [k(KEY_ENTER), b(JOY_BUTTON_A)],
		InputActionName.MENU_BACK: [k(KEY_BACKSPACE), b(JOY_BUTTON_B)],
		InputActionName.MENU_CLOSE: [k(KEY_ESCAPE), b(JOY_BUTTON_BACK)],
		InputActionName.PAUSE: [k(KEY_ESCAPE), b(JOY_BUTTON_START)],
		InputActionName.UNPAUSE: [k(KEY_ESCAPE), b(JOY_BUTTON_START)],
	}
	for action_name_id:InputActionName in all_inputs.keys():
		for event:InputEvent in all_inputs[action_name_id]:
			var action_name := action_name_of(action_name_id)
			if not InputMap.has_action(action_name): InputMap.add_action(action_name)
			InputMap.action_add_event(action_name, event)

static func k(key_code:Key) -> InputEventKey:
	var iek := InputEventKey.new()
	iek.physical_keycode = key_code
	return iek

static func a(axis_code:JoyAxis, axis_signal:float=1.0) -> InputEventJoypadMotion:
	var iejm := InputEventJoypadMotion.new()
	iejm.axis = axis_code
	iejm.axis_value = axis_signal
	return iejm

static func b(button_code:JoyButton) -> InputEventJoypadButton:
	var iejb := InputEventJoypadButton.new()
	iejb.button_index = button_code
	return iejb

static func action_name_of(action_enum_id:InputActionName) -> String:
	match action_enum_id:
		InputActionName.PAUSE: return 'pause'
		InputActionName.UNPAUSE: return 'unpause'
		InputActionName.MENU_CLOSE: return 'menu-close'
		InputActionName.MENU_ACCEPT: return 'menu-accept'
		InputActionName.MENU_BACK: return 'menu-back'
		InputActionName.PLAYER_UP: return 'player-up'
		InputActionName.PLAYER_DOWN: return 'player-down'
		InputActionName.PLAYER_LEFT: return 'player-left'
		InputActionName.PLAYER_RIGHT: return 'player-right'
		InputActionName.PLAYER_JUMP: return 'player-jump'
		InputActionName.PLAYER_DASH: return 'player-dash'
		InputActionName.PLAYER_ROLL: return 'player-roll'
		InputActionName.PLAYER_ATTACK: return 'player-attack'
		_: return 'unknown-action'


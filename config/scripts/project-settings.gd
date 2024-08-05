class_name Z_ProjectSettings extends RefCounted

static var pallete_colors := []

static func setup_default_project_metadata():
	var project_metadata_file_path = 'res://.godot/editor/project_metadata.cfg'
	var hex_file_url = 'https://lospec.com/palette-list/purplemorning8.hex'
	var pallete_file_path = 'res://palette.hex'

	if not FileAccess.file_exists(pallete_file_path):
		var http_request := HTTPRequest.new()
		http_request.download_file = pallete_file_path
		Z_Util.scene_tree().root.add_child(http_request)
		await http_request.ready
		http_request.request(hex_file_url)
		http_request.request_completed.connect(func(res, status, headers, body:PackedByteArray): printt(res, status, headers, body))
		await http_request.request_completed
		http_request.queue_free()

	var fa := FileAccess.open(pallete_file_path, FileAccess.READ)
	var lines := fa.get_as_text().split('\n')
	fa.close()
	for line:String in lines:
		if not line or line.is_empty(): continue
		pallete_colors.push_back(Color('#' + line.strip_edges()))

	var project_metadata = ConfigFile.new()
	project_metadata.load(project_metadata_file_path)
	var preset_colors := project_metadata.get_value('color_picker', 'presets') as PackedColorArray
	var colors_to_add := []
	var preset_colors_as_html := []
	for color in preset_colors:
		preset_colors_as_html.push_back(color.to_html())
	for color in pallete_colors:
		if preset_colors_as_html.has(color.to_html()): continue
		colors_to_add.push_back(color)
	for color in colors_to_add:
		preset_colors.push_back(color)
	if colors_to_add.is_empty(): return
	printt('colors to add', colors_to_add.map(func (c): return c.to_html()))
	project_metadata.set_value('color_picker', 'presets', preset_colors)
	project_metadata.save(project_metadata_file_path)

static func setup_default_project_settings():
	if not OS.is_debug_build(): return
	var folder_colors := {
		"res://addons/": "gray",
		"res://zaft/game/": "purple",
		"res://zaft/lib/": "red",
		"res://zaft/test/": "pink",
		"res://zaft/template/": "teal",
		"res://zaft/sink/": "black",
		"res://game/": "purple",
		"res://lib/": "red",
		"res://test/": "pink",
		"res://template/": "teal",
		"res://sink/": "black",
	}
	var project_settings = {
		'application/config/name': 'Sink',
		'audio/buses/default_bus_layout': 'res://zaft/lib/audio/resources/default_bus_layout.tres',
		'autoload/__z': '*res://zaft/lib/autoload/all.gd',
		'debug/gdscript/warnings/unused_signal': 0,
		'display/window/size/viewport_width': 1366,
		'display/window/size/viewport_height': 768,
		'display/window/stretch/mode': 'viewport',
		'file_customization/folder_colors': folder_colors,
		'rendering/textures/canvas_textures/default_texture_filter': 0,
		'rendering/viewport/hdr_2d': true,
		'rendering/environment/defaults/default_clear_color': Color.HOT_PINK if pallete_colors.is_empty() else pallete_colors[0],
		'rendering/environment/defaults/default_environment': 'res://zaft/lib/config/environment/default-world-environment.tres',
		'editor/naming/script_name_casing': 3,
		'editor/naming/scene_name_casing': 3,
	}
	if project_settings.keys().reduce(func (changed, key):
		var new_val = project_settings.get(key)
		var old_val = ProjectSettings.get_setting(key)
		var different : bool = new_val != old_val
		if new_val is Color and old_val is Color: different = new_val.to_html() != old_val.to_html()
		if different: ProjectSettings.set_setting(key, new_val)
		return changed or different, false):
		ProjectSettings.save()
	

static func setup_default_input_actions():
	if not OS.is_debug_build(): return
	var input_actions := [
		'pause',
		'unpause',
		'menu-close',
		'menu-accept',
		'menu-back',
		'player-up',
		'player-down',
		'player-left',
		'player-right',
		'player-jump',
		'player-dash',
		'player-roll',
		'player-attack',
	]
	for input_action in input_actions:
		if not InputMap.has_action(input_action): InputMap.add_action(input_action)

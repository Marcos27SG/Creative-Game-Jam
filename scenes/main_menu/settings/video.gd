class_name SettingsPanelVideo extends Control

@export var display_mode_left_button: TextureButton
@export var display_mode_right_button: TextureButton
@export var display_mode_label_label: Label
@export var display_mode_label: Label
@export var display_res_left_button: TextureButton
@export var display_res_right_button: TextureButton
@export var display_res_label_label: Label
@export var display_res_label: Label

const DISPLAY_MODE_STR_KEYS = {

	DisplayServer.WINDOW_MODE_FULLSCREEN: "Full Screen", 
	DisplayServer.WINDOW_MODE_WINDOWED: "Windowed"
}

var _display_mode_idx = 0

func _ready() -> void :

	display_mode_left_button.pressed.connect( func(): _set_display_mode(-1))
	display_mode_right_button.pressed.connect( func(): _set_display_mode(1))
	display_mode_left_button.focus_entered.connect( func(): display_mode_label_label.add_theme_color_override("font_color", "eaaded"))
	display_mode_left_button.focus_exited.connect( func(): display_mode_label_label.remove_theme_color_override("font_color"))
	display_mode_right_button.focus_entered.connect( func(): display_mode_label_label.add_theme_color_override("font_color", "eaaded"))
	display_mode_right_button.focus_exited.connect( func(): display_mode_label_label.remove_theme_color_override("font_color"))
	_display_mode_idx = SettingsManager.preferred_display_mode
	_set_display_mode(0, false)

   
	display_res_left_button.pressed.connect( func(): _set_display_res(-1))
	display_res_right_button.pressed.connect( func(): _set_display_res(1))
	display_res_left_button.focus_entered.connect( func(): display_res_label_label.add_theme_color_override("font_color", "eaaded"))
	display_res_left_button.focus_exited.connect( func(): display_res_label_label.remove_theme_color_override("font_color"))
	display_res_right_button.focus_entered.connect( func(): display_res_label_label.add_theme_color_override("font_color", "eaaded"))
	display_res_right_button.focus_exited.connect( func(): display_res_label_label.remove_theme_color_override("font_color"))
	_display_res_idx = SettingsManager.preferred_resolution
	_set_display_res(0, false)
#
	#InputManager.SchemeChanged.connect(_on_scheme_changed)
	#_on_scheme_changed(InputManager._current_scheme)

func _set_display_mode(delta: int, save: bool = true) -> void :
	_display_mode_idx = clampi(_display_mode_idx + delta, 0, DisplayManager.DISPLAY_MODES.size() - 1)
	display_mode_label.text = DISPLAY_MODE_STR_KEYS[DisplayManager.DISPLAY_MODES[_display_mode_idx]]

	display_mode_left_button.disabled = true if _display_mode_idx == 0 else false
	display_mode_right_button.disabled = true if _display_mode_idx == DisplayManager.DISPLAY_MODES.size() - 1 else false

	DisplayManager.set_display_mode(DisplayManager.DISPLAY_MODES[_display_mode_idx])
	if save:
		SettingsManager.preferred_display_mode = _display_mode_idx
		SettingsManager.save_settings()

func _toggle_display_mode_selection(enabled: bool) -> void :
	display_mode_left_button.disabled = !enabled
	display_mode_right_button.disabled = !enabled
	if !enabled: display_mode_label.add_theme_color_override("font_color", Color("#7f708a"))
	else: display_mode_label.remove_theme_color_override("font_color")

var _display_res_idx = 0
func _set_display_res(delta: int, save: bool = true) -> void :
	_display_res_idx = clampi(_display_res_idx + delta, 0, DisplayManager.DISPLAY_RESOLUTIONS.size() - 1)
	display_res_left_button.disabled = true if _display_res_idx == 0 else false
	display_res_right_button.disabled = true if _display_res_idx == DisplayManager.DISPLAY_RESOLUTIONS.size() - 1 else false

	var res = DisplayManager.DISPLAY_RESOLUTIONS[_display_res_idx]
	display_res_label.text = "%d x %d" % [res.x, res.y]
	DisplayManager.set_resolution(res)
	if save:
		SettingsManager.preferred_resolution = _display_res_idx
		SettingsManager.save_settings()

func _toggle_display_resolution_selection(enabled: bool) -> void :
	display_res_left_button.disabled = !enabled
	display_res_right_button.disabled = !enabled
	if !enabled: display_res_label.add_theme_color_override("font_color", Color("#7f708a"))
	else: display_res_label.remove_theme_color_override("font_color")

#func _on_scheme_changed(scheme: InputManager.Scheme) -> void :
#
	#var focus_type: Control.FocusMode = Control.FOCUS_NONE if scheme == InputManager.Scheme.KEYBOARD_AND_MOUSE else Control.FOCUS_ALL
#
	#display_mode_left_button.focus_mode = focus_type
	#display_mode_right_button.focus_mode = focus_type
	#display_res_left_button.focus_mode = focus_type
	#display_res_right_button.focus_mode = focus_type

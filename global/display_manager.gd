extends Node

const DISPLAY_MODES: Array[DisplayServer.WindowMode] = [

	DisplayServer.WINDOW_MODE_FULLSCREEN, 
	DisplayServer.WINDOW_MODE_WINDOWED, 
]
const DISPLAY_RESOLUTIONS: Array[Vector2] = [
	Vector2(1280, 720), 
	Vector2(1280, 800), 
	Vector2(1920, 1080), 
	Vector2(1920, 1200), 
]

var ui_theme: Theme = preload("res://assets/theme/ui_theme.tres")
#var commander_bar_theme: Theme = preload("res://ui/commander_bar_ui_theme.tres")
var main_menu_theme: Theme = preload("res://assets/theme/main_menu_theme.tres")

const NON_PIXEL_FONT = preload("res://assets/theme/Oxanium-Medium.ttf")
const PIXEL_FONT_SIZE = 20
const NON_PIXEL_FONT_SIZE = 16

func set_display_mode(mode: DisplayServer.WindowMode) -> void :
	DisplayServer.call_deferred("window_set_mode", mode)
	if mode == DisplayServer.WINDOW_MODE_WINDOWED:
		self.call_deferred("set_resolution", DISPLAY_RESOLUTIONS[SettingsManager.preferred_resolution])

func set_resolution(res: Vector2) -> void :
	DisplayServer.call_deferred("window_set_size", res)
	var window = get_window()
	window.call_deferred("move_to_center")

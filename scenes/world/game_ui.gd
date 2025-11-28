class_name GameUI extends Control

@export var show_settings_button: Button
@export var settings_ui: SettingsUI
static  var _instance: GameUI



static func instance() -> GameUI:
	return _instance

func _ready() -> void :
	_connect_signals()
	_instance = self


func _connect_signals() -> void :
	show_settings_button.pressed.connect( func(): show_settings_ui())
	Events.settings_closed.connect(hide_settings_ui)



func show_settings_ui() -> void :
	#if World.instance().get_last_selected_entity() != null:
		#World.instance().unselect_last_selected_entity()

	#if reward_selection_ui.visible:
		#return


	if settings_ui.showing_settings_ui:
		return
	#Game.instance().pause_game()
	settings_ui.show_and_fade_in()


func hide_settings_ui() -> void :
	
	if settings_ui.hiding_settings_ui:
		return

	RunManager.instance().unpause_game()
	settings_ui.hide_and_fade_out()

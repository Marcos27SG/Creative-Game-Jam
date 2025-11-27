class_name SettingsUI extends Control

@export var main: Control

@export_category("Main Section")

@export var video_button: Button
@export var audio_button: Button
@export var language_button: Button

@export var exit_game_button: Button
@export var exit_to_desktop_button: Button
@export var close_button: Button

@export_category("Panels")
@export var video_panel: SettingsPanelVideo
@export var audio_panel: SettingsPanelAudio
@export var language_panel: SettingsPanelLanguage


var _visibility_tween: Tween = null
var _ui_cancel_callable: Callable
var _currently_viewed_section: String = ""

func _ready() -> void :
	check_in_game_settings()
	#hide()
	_ui_cancel_callable = _default_ui_cancel_callable

	
	video_button.focus_entered.connect(show_video_section)
	audio_button.focus_entered.connect(show_audio_section)
	language_button.focus_entered.connect(show_language_section)
	
	video_button.pressed.connect(video_button_pressed)
	audio_button.pressed.connect(audio_button_pressed)
	language_button.pressed.connect(language_button_pressed)


	exit_game_button.pressed.connect(_save_and_quit)
	exit_to_desktop_button.pressed.connect(_exit_to_desktop)
	close_button.pressed.connect( func(): Events.settings_closed.emit())


	#InputManager.SchemeChanged.connect(_on_scheme_changed)
	#_on_scheme_changed(InputManager._current_scheme)


var _settings_visible: bool = false
var showing_settings_ui: bool = false
func show_and_fade_in() -> void :
	showing_settings_ui = true
	if _visibility_tween != null && _visibility_tween.is_running():
		_visibility_tween.kill()
		hiding_settings_ui = false

	var in_game = Game.instance() != null
	exit_game_button.visible = in_game
	exit_to_desktop_button.visible = in_game

	_settings_visible = true
	show()
	modulate = Color.WHITE
	main.show()
	main.modulate = Color(Color.WHITE, 0.0)
	_visibility_tween = create_tween()
	_visibility_tween.tween_property(main, "modulate", Color.WHITE, 0.15).set_ease(Tween.EASE_IN)
	_visibility_tween.tween_property(self, "showing_settings_ui", false, 0)


var hiding_settings_ui: bool = false
func hide_and_fade_out() -> void :
	hiding_settings_ui = true
	if _visibility_tween != null && _visibility_tween.is_running():
		_visibility_tween.kill()
		showing_settings_ui = false

	_visibility_tween = create_tween()
	_visibility_tween.tween_property(self, "modulate", Color(Color.WHITE, 0.0), 0.15).set_ease(Tween.EASE_IN)
	_visibility_tween.tween_callback(
		func():
			_settings_visible = false
			hiding_settings_ui = false
			main.hide()
			hide()
	)

	get_viewport().gui_release_focus()





func show_audio_section() -> void :
	#title_label.text = "KEY_SETTINGS_UI_AUDIO"
	_currently_viewed_section = "audio"
	hide_all_sections()
	audio_panel.show()

func audio_button_pressed() -> void :
	show_audio_section()


func show_language_section() -> void :
	#title_label.text = "KEY_SETTINGS_UI_LANGUAGE"
	_currently_viewed_section = "language"
	hide_all_sections()
	language_panel.show()

func language_button_pressed() -> void :
	show_language_section()



func show_video_section() -> void :
	#title_label.text = "KEY_SETTINGS_UI_VIDEO"
	_currently_viewed_section = "video"
	hide_all_sections()
	video_panel.show()

func video_button_pressed() -> void :
	show_video_section()

func hide_all_sections() -> void :
	audio_panel.hide()
	language_panel.hide()
	video_panel.hide()

func _unhandled_input(event: InputEvent) -> void :
	if _settings_visible:
		if event.is_action_pressed("ui_cancel"):
			_ui_cancel_callable.call()
		get_viewport().set_input_as_handled()

func _default_ui_cancel_callable() -> void :
	Events.settings_closed.emit()


func _save_and_quit() -> void :
	Events.save_and_quit_pressed.emit()


func _exit_to_desktop() -> void :
	Events.exit_to_desktop_pressed.emit()
	
func check_in_game_settings() -> void:
	if Events.in_game:
		exit_game_button.show()
		exit_to_desktop_button.show()
	else:
		exit_game_button.hide()
		exit_to_desktop_button.hide()

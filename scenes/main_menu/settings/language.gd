class_name SettingsPanelLanguage extends Control

@export var english_language_button: Button
@export var spanish_language_button: Button

func _ready() -> void :
	english_language_button.pressed.connect( func(): _on_language_selected("en_US"))
	spanish_language_button.pressed.connect( func(): _on_language_selected("es_ES"))

func _on_language_selected(locale: String) -> void :
	TranslationServer.set_locale(locale)
	#Events.locale_changed.emit(locale)
	SettingsManager.preferred_locale = locale
	SettingsManager.save_settings()

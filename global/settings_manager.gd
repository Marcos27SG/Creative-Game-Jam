extends Node

const SETTINGS_FILE_URI = "user://test.json"

var master_volume: int
var music_volume: int
var effects_volume: int
var preferred_locale: String
var preferred_display_mode: int
var preferred_resolution: int
var show_dmg_numbers: bool
var show_regen_numbers: bool
var slow_mo_on_skills: bool
var slow_mo_on_towers: bool
var show_corruption_effect: bool
var use_pixel_font: bool
var allow_moving_night_bg: bool

func _ready():
	_ensure_settings_file_exists()
	_load_settings()

func _ensure_settings_file_exists():
	if FileAccess.file_exists(SETTINGS_FILE_URI):
		return

	master_volume = 50
	music_volume = 50
	effects_volume = 50
	preferred_display_mode = 1
	preferred_resolution = 2
	show_dmg_numbers = true
	show_regen_numbers = true
	slow_mo_on_skills = true
	slow_mo_on_towers = false
	show_corruption_effect = true
	use_pixel_font = false
	allow_moving_night_bg = true
	save_settings()

func _load_settings():
	var settings_file = FileAccess.open(SETTINGS_FILE_URI, FileAccess.READ)
	var json_string = settings_file.get_line()
	var json = JSON.new()
	var parse_result = json.parse(json_string)
	assert (
		parse_result == OK, 
		"_load_settings: JSON Parse Error: %s in json_string at line %s" % [json.get_error_message(), json.get_error_line()]
	)

	var data = json.get_data()
	master_volume = data.master_volume
	SFXManager.set_master_bus_level(master_volume)
	music_volume = data.music_volume
	SFXManager.set_music_bus_level(music_volume)
	effects_volume = data.effects_volume
	SFXManager.set_effects_bus_level(effects_volume)

	if data.has("preferred_locale") && data["preferred_locale"] != "":
		preferred_locale = data.preferred_locale
		TranslationServer.set_locale(preferred_locale)
	else:
		preferred_locale = OS.get_locale()
		if !is_supported_locale(preferred_locale):
			preferred_locale = get_fallback_locale()
		TranslationServer.set_locale(preferred_locale)

	#if Steam.isSteamRunning() && Steam.isSteamRunningOnSteamDeck():
		#preferred_display_mode = 0
		#preferred_resolution = 1
	
		preferred_display_mode = data.preferred_display_mode if data.has("preferred_display_mode") else 0
		preferred_resolution = data.preferred_resolution if data.has("preferred_resolution") else 2

	DisplayManager.set_display_mode(DisplayManager.DISPLAY_MODES[preferred_display_mode])
	DisplayManager.set_resolution(DisplayManager.DISPLAY_RESOLUTIONS[preferred_resolution])

	show_dmg_numbers = data.get("show_dmg_numbers", true)
	show_regen_numbers = data.get("show_regen_numbers", true)

	slow_mo_on_skills = data.get("slow_mo_on_skills", true)
	slow_mo_on_towers = data.get("slow_mo_on_towers", false)

	show_corruption_effect = data.get("show_corruption_effect", true)

	use_pixel_font = false


	allow_moving_night_bg = data.get("allow_moving_night_bg", true)

const SUPPORTED_LOCALE = [
	"en_US", "zh_CN", "zh_TW", "de_DE", "fr_FR", "es_ES", "ja_JP", "ko_KR"
]
func is_supported_locale(locale: String) -> bool:
	return locale in SUPPORTED_LOCALE

func get_fallback_locale() -> String:

	var system_language = OS.get_locale_language()
	var default_locale = "en_US"
	for locale in SUPPORTED_LOCALE:
		if locale.begins_with(system_language):
			return locale


	return default_locale

func save_settings():
	var settings_file = FileAccess.open(SETTINGS_FILE_URI, FileAccess.WRITE)
	settings_file.store_line(
		JSON.stringify({
			"master_volume": master_volume, 
			"music_volume": music_volume, 
			"effects_volume": effects_volume, 
			"preferred_locale": preferred_locale, 
			"preferred_display_mode": preferred_display_mode, 
			"preferred_resolution": preferred_resolution, 
			"show_dmg_numbers": show_dmg_numbers, 
			"show_regen_numbers": show_regen_numbers, 
			"slow_mo_on_skills": slow_mo_on_skills, 
			"slow_mo_on_towers": slow_mo_on_towers, 
			"show_corruption_effect": show_corruption_effect, 
			"use_pixel_font": use_pixel_font, 
			"allow_moving_night_bg": allow_moving_night_bg, 
		})
	)
	settings_file.flush()
	settings_file.close()

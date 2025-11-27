class_name SettingsPanelAudio extends Control

@export var master_volume_label: Label
@export var master_volume_slider: HSlider
@export var master_volume_value_label: Label
@export var music_volume_label: Label
@export var music_volume_slider: HSlider
@export var music_volume_value_label: Label
@export var effects_volume_label: Label
@export var effects_volume_slider: HSlider
@export var effects_volume_value_label: Label

func _ready() -> void :
	master_volume_slider.value_changed.connect(_on_master_volume_changed)
	master_volume_slider.focus_entered.connect( func(): master_volume_label.add_theme_color_override("font_color", "eaaded"))
	master_volume_slider.focus_exited.connect( func(): master_volume_label.remove_theme_color_override("font_color"))
	music_volume_slider.value_changed.connect(_on_music_volume_changed)
	music_volume_slider.focus_entered.connect( func(): music_volume_label.add_theme_color_override("font_color", "eaaded"))
	music_volume_slider.focus_exited.connect( func(): music_volume_label.remove_theme_color_override("font_color"))
	effects_volume_slider.value_changed.connect(_on_effects_volume_changed)
	effects_volume_slider.focus_entered.connect( func(): effects_volume_label.add_theme_color_override("font_color", "eaaded"))
	effects_volume_slider.focus_exited.connect( func(): effects_volume_label.remove_theme_color_override("font_color"))

	master_volume_slider.value = SettingsManager.master_volume
	_on_master_volume_changed(SettingsManager.master_volume)
	music_volume_slider.value = SettingsManager.music_volume
	_on_music_volume_changed(SettingsManager.music_volume)
	effects_volume_slider.value = SettingsManager.effects_volume
	_on_effects_volume_changed(SettingsManager.effects_volume)

func _on_master_volume_changed(val: float) -> void :
	master_volume_value_label.text = "%s" % [int(val)]
	SFXManager.set_master_bus_level(val)
	SettingsManager.master_volume = int(val)
	SettingsManager.save_settings()

func _on_music_volume_changed(val: float) -> void :
	music_volume_value_label.text = "%s" % [int(val)]
	SFXManager.set_music_bus_level(val)
	SettingsManager.music_volume = int(val)
	SettingsManager.save_settings()

func _on_effects_volume_changed(val: float) -> void :
	effects_volume_value_label.text = "%s" % [int(val)]
	SFXManager.set_effects_bus_level(val)
	SettingsManager.effects_volume = int(val)
	SettingsManager.save_settings()

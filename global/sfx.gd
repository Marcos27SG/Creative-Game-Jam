extends Node

var sfx_dict = {}

@export var sound_effects_data: Array[SFXData]
@onready var master_bus_idx = AudioServer.get_bus_index("Master")
@onready var music_bus_idx = AudioServer.get_bus_index("Music")
@onready var sfx_bus_idx = AudioServer.get_bus_index("SFX")

const lower_sound_level_factor: float = 0.45

var volume_tween: Tween

func _ready():
	for data: SFXData in sound_effects_data:
		sfx_dict[data.type] = data
		
	print("Master bus index: ", master_bus_idx)
	print("Music bus index: ", music_bus_idx)
	print("SFX bus index: ", sfx_bus_idx)

func _notification(what):
	if what == NOTIFICATION_WM_WINDOW_FOCUS_IN:
		AudioServer.set_bus_mute(master_bus_idx, false)
	elif what == NOTIFICATION_WM_WINDOW_FOCUS_OUT:
		AudioServer.set_bus_mute(master_bus_idx, true)

func lower_sound_volume():
	if volume_tween != null && volume_tween.is_valid():
		volume_tween.stop()

	volume_tween = create_tween()
	var master_volume = SettingsManager.master_volume
	volume_tween.tween_method(set_master_bus_level, master_volume, master_volume * lower_sound_level_factor, 1.5)

func restore_sound_volume():
	if volume_tween != null && volume_tween.is_valid():
		volume_tween.stop()

	volume_tween = create_tween()
	var master_volume = SettingsManager.master_volume
	volume_tween.tween_method(set_master_bus_level, master_volume * lower_sound_level_factor, master_volume, 2.5)

func set_master_bus_level(level: float) -> void :
	AudioServer.set_bus_volume_db(master_bus_idx, linear_to_db(level / 100))

func set_music_bus_level(level: float) -> void :
	AudioServer.set_bus_volume_db(music_bus_idx, linear_to_db(level / 100))

func set_effects_bus_level(level: float) -> void :
	AudioServer.set_bus_volume_db(sfx_bus_idx, linear_to_db(level / 100))

func create_2d_audio_at_location(location, type: SFXData.Type):
	if sfx_dict.has(type):
		var data: SFXData = sfx_dict[type]
		if data.has_open_limit():
			data.change_audio_count(1)
			var new_2D_audio = AudioStreamPlayer2D.new()
			add_child(new_2D_audio)
			new_2D_audio.bus = "SFX"

			new_2D_audio.global_position = location
			new_2D_audio.stream = data.sound_effect
			new_2D_audio.volume_db = data.volume
			new_2D_audio.pitch_scale = data.pitch_scale
			new_2D_audio.pitch_scale += randf_range( - data.pitch_randomness, data.pitch_randomness)
			new_2D_audio.finished.connect(data.on_audio_finished)
			new_2D_audio.finished.connect(new_2D_audio.queue_free)

			new_2D_audio.play()

	else:
		push_error("Audio Manager failed to find setting for type ", type)


func create_audio(type: SFXData.Type):
	if sfx_dict.has(type):
		var data: SFXData = sfx_dict[type]
		if data.has_open_limit():
			data.change_audio_count(1)
			var new_audio = AudioStreamPlayer.new()
			new_audio.bus = "SFX"
			add_child(new_audio)

			new_audio.stream = data.sound_effect
			new_audio.volume_db = data.volume
			new_audio.pitch_scale = data.pitch_scale
			new_audio.pitch_scale += randf_range( - data.pitch_randomness, data.pitch_randomness)
			new_audio.finished.connect(data.on_audio_finished)
			new_audio.finished.connect(new_audio.queue_free)

			new_audio.play()
	else:
		push_error("Audio Manager failed to find setting for type ", type)

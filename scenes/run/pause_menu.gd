class_name PauseMenu
extends CanvasLayer

signal save_and_quit


#@onready var back_to_game_button: Button = %BackToGameButton
#@onready var save_and_quit_button: Button = %SaveAndQuitButton
@onready var settings_menu: Control = $SettingsMenu
@onready var save_quit: Button = $SaveQuit
@onready var go_back: Button = $GoBack

#@onready var settings_menu: SettingsMenu = $SettingsMenu

func _ready() -> void:
	#settings_menu.show_pause_menu_from_game
	go_back.pressed.connect(_unpause)
	save_quit.pressed.connect(_on_save_and_quit_button_pressed)
	
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		if visible:
			_unpause()
			print("unpause")
		else:
			_pause()
			print("pause")
		get_viewport().set_input_as_handled()

func _pause() -> void:
	#settings_menu.language_option_button.visible = false
	#settings_menu.language.visible = false
	show()
	get_tree().paused = true
	
func _unpause() -> void:
	
	hide()
	get_tree().paused = false
	
func _on_save_and_quit_button_pressed() -> void:
	get_tree().paused = false
	save_and_quit.emit()

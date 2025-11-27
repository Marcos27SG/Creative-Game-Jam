extends Control

const RUN = preload("res://scenes/run/run.tscn")
#const run scene
# const settings menu
@onready var continue_button: Button = $MainMenu/VBoxContainer/Continue
@onready var new_run: Button = $"MainMenu/VBoxContainer/New Run"
@onready var options: Button = $MainMenu/VBoxContainer/Options
@onready var exit: Button = $MainMenu/VBoxContainer/Exit
@onready var main_menu: CanvasLayer = $MainMenu
@onready var options_menu: CanvasLayer = $OptionsMenu
@onready var return_button: Button = %ReturnButton
@onready var quit_button: Button = %QuitButton



var original_texts: Dictionary ={}


func _ready() -> void:
	get_tree().paused = false
	continue_button.disabled = true
	Events.settings_closed.connect(_on_return_button_pressed)



func _on_new_run_pressed() -> void:
	get_tree().change_scene_to_packed(RUN)
	



func _on_options_pressed() -> void:
	main_menu.hide()
	options_menu.show()



func _on_return_button_pressed() -> void:
	main_menu.show()
	options_menu.hide()
	get_tree().paused = false
	



func _on_quit_button_pressed() -> void:
	get_tree().quit()
	



func _on_exit_pressed() -> void:
	get_tree().quit()

class_name RunManager
extends Node

static  var _instance: RunManager

static func instance() -> RunManager:
	return _instance


const WORLD_SCENE := preload("res://scenes/world/world.tscn")
const MAIN_MENU_PATH := "res://scenes/main_menu/main_menu.tscn"
@onready var current_view: Node3D = $CurrentView

@onready var world: World = $CurrentView/World

var world_scene: Node3D
var arena_scene: Node3D
var world_camera: Camera3D
var arena_camera: Camera3D
var current_mode: String = "world"

func _ready() -> void:
	_instance = self
	Events.in_game = true
	
	Events.save_and_quit_pressed.connect(_on_save_and_quit_pressed)
	
	Events.exit_to_desktop_pressed.connect(_on_exit_to_desktop_pressed)


var _paused_count: int = 0
func is_paused() -> bool:
	return _paused_count > 0

func pause_game() -> void :

	if _paused_count == 0:
		get_tree().paused = true
		pause_background()
	_paused_count += 1

func unpause_game() -> void :
	if _paused_count <= 0:
		return
	_paused_count -= 1
	if _paused_count == 0:
		get_tree().paused = false
		resume_background()

func force_unpause_game() -> void :
	_paused_count = 0
	get_tree().paused = false
	resume_background()
	
	
	
	
func _on_save_and_quit_pressed() -> void :
	#Game.instance().force_unpause_game()
	#ResourceDatabases.enemy_spawn_database._wave_cancelled = true
	get_tree().change_scene_to_file("res://scenes/main_menu/main_menu.tscn")
	Events.in_game = false
	#_game_state_machine.transition_to(
		#GameStateMachine.State.CLEANUP, 
	#)



func _on_exit_to_desktop_pressed() -> void :
	get_tree().quit()
func pause_background() -> void :
	pass
	#night_warning_texture.paused = true

func resume_background() -> void :
	pass

class_name RunManager
extends Node

const WORLD_SCENE := preload("res://scenes/world/world.tscn")
const MAIN_MENU_PATH := "res://scenes/main_menu/main_menu.tscn"
@onready var current_view: Node3D = $CurrentView
@onready var pause_menu: CanvasLayer = $PauseMenu
@onready var arena_button: Button = $ArenaButton
@onready var world_button: Button = $WorldButton
@onready var world: World = $CurrentView/World

var world_scene: Node3D
var arena_scene: Node3D
var world_camera: Camera3D
var arena_camera: Camera3D
var current_mode: String = "world"

func _ready() -> void:
	pause_menu.save_and_quit.connect(
		func():
			get_tree().change_scene_to_file(MAIN_MENU_PATH)
	)

	world_camera = world.world_camera_3d
	#arena_camera = battle.battle_camera_3d
	#_activate_world()


#func _on_arena_button_pressed() -> void:
	#if current_mode == "arena":
		#return
	#_activate_arena()
#
#func _on_world_button_pressed() -> void:
	#if current_mode == "world":
		#return
	#_activate_world()
#
#func _activate_world() -> void:
	#current_mode = "world"
	#arena_button.visible = true
	#world_button.visible = false
	## Switch cameras
	#if arena_camera:
		#arena_camera.current = false
		#battle.battle_ui.visible = false
	#if world_camera:
		#world_camera.current = true
		#world.world_ui.visible = true
#
#
#func _activate_arena() -> void:
	#current_mode = "arena"
	#arena_button.visible = false
	#world_button.visible = true
	## Switch cameras
	#if world_camera:
		#world_camera.current = false
		#world.world_ui.visible = false
	#if arena_camera:
		#arena_camera.current = true
		#battle.battle_ui.visible = true

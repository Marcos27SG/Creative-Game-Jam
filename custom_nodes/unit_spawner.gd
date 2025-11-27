class_name UnitSpawner
extends Node

#signal unit_spawned(unit: Unit)

#const UNIT = preload("res://scenes/unit/unit.tscn")
#@export var bench: PlayArea
#@export var game_area: PlayArea
#@export var game_state: GameState
#@onready var unit_scene_spawner: SceneSpawner = $SceneSpawner
#
#
#func _ready() -> void:
	#pass
	##var BJORN = preload("res://data/units/bjorn.tres")
	##var ARTHUR = preload("res://data/units/arthur.tres")
	##var ROBIN = preload("res://data/units/robin.tres")
	##var tween := create_tween()
	##
	##tween.tween_callback(spawn_unit.bind(BJORN))
	##tween.tween_callback(spawn_unit.bind(ARTHUR))
	##tween.tween_callback(spawn_unit.bind(ROBIN))
	##tween.tween_interval(0.5)
#func _get_first_available_area() -> PlayArea:
	#var bench_full := bench.unit_grid.is_grid_full()
	#var game_area_full := game_area.unit_grid.is_grid_full()
	#var is_battling := game_state.current_phase == GameState.Phase.BATTLE
	#if not bench_full:
		#return bench
	#elif not game_area_full and not is_battling:
		#return game_area
	#return null
#
#
#func spawn_unit(unit: UnitStats) -> void:
	#var area := _get_first_available_area()
	## TODO in the future, throw a popup error message here!
	#assert(area, "No available space to add unit to!")
	#
	#var new_unit := unit_scene_spawner.spawn_scene(area.unit_grid) as Unit
	#var tile := area.unit_grid.get_first_empty_tile()
	##area.unit_grid.add_child(new_unit)
	#area.unit_grid.add_unit(tile, new_unit)
	#new_unit.global_position = area.get_global_from_tile(tile) + Vector3(0.05,0.3,0.05)
	#new_unit.stats = unit
	#
	#unit_spawned.emit(new_unit)

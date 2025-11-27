class_name UnitMover
extends Node
#
#@export var play_areas: Array[PlayArea]
#@export var unit_place_sound: AudioStream
#@export var game_state : GameState
#
#func _ready() -> void:
	#var units := get_tree().get_nodes_in_group("units")
	#for unit: Unit in units:
		#setup_unit(unit)
#
#func setup_unit(unit: Unit) -> void:
	#unit.drag_and_drop.drag_started.connect(_on_unit_drag_started.bind(unit))
	#unit.drag_and_drop.drag_canceled.connect(_on_unit_drag_canceled.bind(unit))
	#unit.drag_and_drop.dropped.connect(_on_unit_dropped.bind(unit))
#
#func _set_highlighters(enabled: bool) -> void:
	#for play_area: PlayArea in play_areas:
		#play_area.tile_highlighter.enabled = enabled
#
#
#func _get_play_area_for_position(global: Vector3) -> int:
	#var dropped_area_index := -1
	#
	#for i in play_areas.size():
		#var tile := play_areas[i].get_tile_from_global(global)  # Convert 3D to 2D
		#if play_areas[i].is_tile_in_bounds(tile):
			#dropped_area_index = i
	#
	#return dropped_area_index
##
#func _reset_unit_to_starting_position(starting_position: Vector3, unit: Unit) -> void:
	#var i := _get_play_area_for_position(starting_position)
	##if i == -1:
		### Fallback: reset to starting position without grid placement
	##	unit.global_position = starting_position
	##	return
	##
	#var tile := play_areas[i].get_tile_from_global(starting_position)
	##
	#unit.reset_after_dragging(starting_position)  # Assuming reset_after_dragging uses Vector2
	#play_areas[i].unit_grid.add_unit(tile, unit)
	#SFXPlayer.play(unit_place_sound)
##
#func _move_unit(unit: Unit, play_area: PlayArea, tile: Vector2i) -> void:
	#play_area.unit_grid.add_unit(tile, unit)
	##var tile_global_2d := play_area.get_global_from_tile(tile) 
	##unit.global_position = Vector3(tile_global_2d.x, unit.global_position.y, tile_global_2d.y)  # Keep Y from 3D position
	#unit.global_position = play_area.get_global_from_tile(tile) + Vector3(0.05,0.3,0.05)
	 ##Vector3(tile_global_2d.x , unit.global_position.y, tile_global_2d.y)
	#unit.reparent(play_area.unit_grid)
	##unit.global_position = unit.global_position + Vector3(0,0.7,0)
##
#func _on_unit_drag_started(unit: Unit) -> void:
	#_set_highlighters(true)
	#
	#var i := _get_play_area_for_position(unit.global_position)
	#if i > -1:
		#var tile := play_areas[i].get_tile_from_global(unit.global_position)
		#play_areas[i].unit_grid.remove_unit(tile)
#
#func _on_unit_drag_canceled(starting_position: Vector3, unit: Unit) -> void:
	#_set_highlighters(false)
	#_reset_unit_to_starting_position(starting_position, unit)
##
#func _on_unit_dropped(starting_position: Vector3, unit: Unit) -> void:
	#_set_highlighters(false)
##
	#var old_area_index := _get_play_area_for_position(starting_position)
	## Use unit's current 3D position, adjusted for drag plane
	#var drop_area_index := _get_play_area_for_position(unit.global_position)
	#var invalid_drop := drop_area_index == -1
	#var bench_to_game := old_area_index == 1 and drop_area_index == 0
	#var is_battling := game_state.current_phase == GameState.Phase.BATTLE
	#
	#if invalid_drop or (bench_to_game and is_battling):
		#_reset_unit_to_starting_position(starting_position, unit)
		#return
#
	#var old_area := play_areas[old_area_index]
	#var old_tile := old_area.get_tile_from_global(starting_position)
	#var new_area := play_areas[drop_area_index]
	#var new_tile := new_area.get_hovered_tile()
	#if not new_area.is_tile_in_bounds(new_tile):
		#_reset_unit_to_starting_position(starting_position, unit)
		#return
	## Swap units if we have to
	#if new_area.unit_grid.is_tile_occupied(new_tile):
		#var old_unit: Unit = new_area.unit_grid.units[new_tile]
		#new_area.unit_grid.remove_unit(new_tile)
		#_move_unit(old_unit, old_area, old_tile)
	#
	#_move_unit(unit, new_area, new_tile)
	#SFXPlayer.play(unit_place_sound)

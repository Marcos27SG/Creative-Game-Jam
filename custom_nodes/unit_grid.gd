class_name UnitGrid
extends Node3D

signal unit_grid_changed

@export var size: Vector2i  # We'll map this to 2D in _ready

var units: Dictionary  # Keys will be Vector2i
var grid_size_2d: Vector2i  # Store the 2D size (X, Z)

func _ready() -> void:
	# Map the 3D size to 2D (using X and Z)
	grid_size_2d = Vector2i(size.x, size.y)
	for x in grid_size_2d.x:
		for y in grid_size_2d.y:
			units[Vector2i(x, y)] = null

func add_unit(tile: Vector2i, unit: Node) -> void:
	units[tile] = unit
	unit.tree_exited.connect(_on_unit_tree_exited.bind(unit, tile))
	# Position the unit in 3D space using PlayArea's method
	#unit.global_position = get_parent().get_global_from_tile(tile)
	unit_grid_changed.emit()

func remove_unit(tile: Vector2i) -> void:
	var unit := units[tile] as Node
	if not unit:
		return
	unit.tree_exited.disconnect(_on_unit_tree_exited)
	units[tile] = null
	unit_grid_changed.emit()

func is_tile_occupied(tile: Vector2i) -> bool:
	return units[tile] != null

func is_grid_full() -> bool:
	return units.keys().all(is_tile_occupied)

func get_first_empty_tile() -> Vector2i:
	for tile in units:
		if not is_tile_occupied(tile):
			return tile
	return Vector2i(-1, -1)

func get_all_units() -> Array[Node]:
	var unit_array: Array[Node] = []
	for unit in units.values():
		if unit:
			unit_array.append(unit)
	return unit_array

func get_all_ocuppied_tiles () -> Array[Vector2i]:
	var tile_array: Array[Vector2i]
	for tile: Vector2i in units.keys():
		if units[tile]:
			tile_array.append(tile)
			
	return tile_array

func _on_unit_tree_exited(unit: Node, tile: Vector2i) -> void:
	if unit.is_queued_for_deletion():
		units[tile] = null
		unit_grid_changed.emit()

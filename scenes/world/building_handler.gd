class_name  BuildingHandler
extends Node

@export var grid_map: GridMap
const BUILDING = preload("res://scenes/buildings/building.tscn")

@export var buildings_to_setup : Array [BuildingData] 

# DP#17 First Iteration working
# TO-DO Set the right mesh index of the buildings 
# randomize resource location
# _place building only place 2x2 for the core engine


func _ready():
	_setup_initial_buildings()

func _setup_initial_buildings():
	pass
	_place_building(buildings_to_setup[0], Vector3i(-1, 0, -4), 0)     # Center
	#_place_build
	#_place_building(buildings_to_setup[1], Vector3i(3, 0, 0), 1)         # Offset

func _place_building(data: BuildingData, origin_cell: Vector3i , mesh_index: int):
	var building = BUILDING.instantiate()
	building.building_data = data
	add_child(building)
	#var test = origin_cell + Vector3i(0, 5, 0) 
	
	# Base world position (top-left cell)
	var world_pos = grid_map.map_to_local(origin_cell)
	
	# Offset to center the building model (if origin is at center of mesh)
	var half_size_offset = Vector3(
		(data.size.x - 1) * 0.5 * grid_map.cell_size.x,
		0,
		(data.size.y - 1) * 0.5 * grid_map.cell_size.z
	)

	building.global_transform.origin = world_pos + half_size_offset

	# Set all occupied cells in the GridMap
	for x in data.size.x:
		for z in data.size.y:
			var cell = origin_cell + Vector3i(x, 0, z)
			grid_map.set_cell_item(cell, mesh_index)

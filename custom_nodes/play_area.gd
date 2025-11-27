class_name PlayArea
extends GridMap

@export var unit_grid: UnitGrid
@export var tile_highlighter: TileHighlighter
@export var selector: Node3D
#@export var camera: Camera3D
#var plane: Plane
var bounds: Rect2i  # Keep as Rect2i since we're using 2D coordinates
#@onready var label: Label = $"../Label"

func _ready() -> void:
	# Map the GridMap's X and Z dimensions to a 2D bounds
	bounds = Rect2i(Vector2.ZERO, unit_grid.size)
	#unit_grid.add_unit(Vector2i(0,0), $"../Bench/Unit")
#func _process(delta: float) -> void:
	#label.text = str(get_hovered_tile())
	#print(get_hovered_tile())
#func _process(delta: float) -> void:
#
	#var world_position = plane.intersects_ray(
		#camera.project_ray_origin(get_viewport().get_mouse_position()),
		#camera.project_ray_normal(get_viewport().get_mouse_position()))
#
	#var gridmap_position = Vector3(round(world_position.x), 0, round(world_position.z))
	#selector.position = lerp(selector.position, gridmap_position, delta * 40)

func get_tile_from_global(global: Vector3) -> Vector2i:
	# Convert a 3D global position to a 2D grid tile (using X and Z)
	#return local_to_map(to_local(global.x , global.z))
	var local_pos = to_local(global)
	var map_pos = local_to_map(local_pos)
	return Vector2i(map_pos.x, map_pos.z)

func get_global_from_tile(tile: Vector2i) -> Vector3:
	# Convert the 2D tile (X, Z) to a 3D grid coordinate (X, 0, Z)
	var grid_pos = Vector3i(tile.x, 0, tile.y)
	# Calculate the local position using the GridMap's cell_size
	var local_pos = Vector3(grid_pos.x, grid_pos.y, grid_pos.z) * cell_size
	var center_offset = cell_size * 0.5
	local_pos += Vector3(center_offset.x, 0, center_offset.z)
	# Convert to global positionqqe
	return to_global(local_pos)
func get_hovered_tile() -> Vector2i:
	# Get the 3D mouse position projected onto a plane at Y=0
	var global_pos = _get_mouse_position_in_3d()
	if global_pos == Vector3.ZERO:  # Invalid position
		return Vector2i(-1, -1)
	return get_tile_from_global(global_pos)

func is_tile_in_bounds(tile: Vector2i) -> bool:
	return bounds.has_point(tile)
#
#func _get_mouse_position_in_3d() -> Vector3:
	#var world_position = plane.intersects_ray(
		#camera.project_ray_origin(get_viewport().get_mouse_position()),
		#camera.project_ray_normal(get_viewport().get_mouse_position()))
	#var gridmap_position = Vector3(round(world_position.x), 0, round(world_position.z))
	#selector.position = lerp(selector.position, gridmap_position, 1 * 40)
	#return gridmap_position
func _get_mouse_position_in_3d() -> Vector3:
	# Get the 3D camera and mouse position
	var camera = get_viewport().get_camera_3d()
	if not camera:
		return Vector3.ZERO

	var mouse_pos = get_viewport().get_mouse_position()
	var from = camera.project_ray_origin(mouse_pos)
	var to = from + camera.project_ray_normal(mouse_pos) * 1000

	# Project the mouse ray onto a plane at Y=0 (no physics)
	var plane = Plane(Vector3(0, 1, 0), 0)  # Plane at Y=0
	var intersection = plane.intersects_ray(from, to)
	return intersection if intersection else Vector3.ZERO

class_name GridHighlight
extends Node3D

# References
@export var grid_map: GridMap
@export var ground_plane: Node3D  # Reference to your ground plane
@export var highlight_radius: int = 2
@export var cell_size: float = 0.95  # Export variable for cell size
@export var height_offset: float = 0.15  # Increased to be above grass

@export var map_min_bounds: Vector3 = Vector3(-8, 0, -8)
@export var map_max_bounds: Vector3 = Vector3(8, 0, 8)
# Colors
@export var valid_color: Color = Color(0.2, 0.8, 0.2, 0.4)
@export var occupied_color: Color = Color(0.8, 0.2, 0.2, 0.4)
@export var out_of_bounds_color: Color = Color(0.5, 0.5, 0.5, 0.2)  # Gray for out of bounds
# Internal
var instances: Array[MeshInstance3D] = []
var current_center: Vector3i = Vector3i.ZERO
var active: bool = false

func _ready():
	create_instances()

func create_instances():
	clear_instances()
	var size = highlight_radius * 2 + 1
	instances.resize(size * size)
	
	var mesh = QuadMesh.new()
	mesh.size = Vector2(cell_size, cell_size)  # Use export variable
	
	for i in instances.size():
		var instance = MeshInstance3D.new()
		instance.mesh = mesh
		instance.rotation = Vector3(-PI/2, 0, 0)
		instance.layers = 32
		instance.sorting_offset = 1000
		instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
		add_child(instance)
		instances[i] = instance

func activate():
	active = true
	for instance in instances:
		instance.visible = true

func deactivate():
	active = false
	for instance in instances:
		instance.visible = false
	
# Check if a position is within map bounds
func is_position_in_bounds(pos: Vector3) -> bool:
	return (pos.x >= map_min_bounds.x and 
			pos.x <= map_max_bounds.x and
			pos.z >= map_min_bounds.z and 
			pos.z <= map_max_bounds.z)

func update_highlight_at_position(pos: Vector3i):
	if not active or not grid_map:
		return
		
	current_center = pos
	var idx = 0
	
	for x in range(-highlight_radius, highlight_radius + 1):
		for z in range(-highlight_radius, highlight_radius + 1):
			if idx >= instances.size():  # Safety check
				break
				
			var cell_pos = current_center + Vector3i(x, 0, z)
			var world_pos = grid_map.to_global(grid_map.map_to_local(cell_pos))
			
			# Get ground height if ground plane exists
			if ground_plane:
				world_pos.y = get_ground_height_at_position(world_pos) + height_offset
			else:
				world_pos.y += height_offset
			
			var instance = instances[idx]
			instance.global_position = world_pos
			
			# Check if cell is actually occupied
			#var is_occupied = grid_map.get_cell_item(cell_pos) != GridMap.INVALID_CELL_ITEM
		# Determine cell state and color
			var cell_color: Color
			var cell_pos_vector3 = Vector3(cell_pos.x, cell_pos.y, cell_pos.z)
			
			if not is_position_in_bounds(cell_pos_vector3):
				# Out of bounds
				cell_color = out_of_bounds_color
			elif grid_map.get_cell_item(cell_pos) != GridMap.INVALID_CELL_ITEM:
				# Occupied
				cell_color = occupied_color
			else:
				# Valid for placement
				cell_color = valid_color
			
			var mat = StandardMaterial3D.new()
			mat.albedo_color = cell_color
			mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
			mat.no_depth_test = true
			mat.flags_unshaded = true
			mat.depth_draw_mode = BaseMaterial3D.DEPTH_DRAW_ALWAYS
			mat.flags_transparent = true
			mat.render_priority = 10
			instance.material_override = mat
			
			idx += 1
		
		if idx >= instances.size():  # Safety check for outer loop too
			break

func get_ground_height_at_position(_world_pos: Vector3) -> float:
	"""Get the height of the ground plane at a given world position"""
	if not ground_plane:
		return 0.0
	
	# If ground plane is flat, just return its Y position
	return ground_plane.global_position.y

func clear_instances():
	for instance in instances:
		if instance:
			instance.queue_free()
	instances.clear()

func is_cell_valid_for_placement(cell_pos: Vector3i, building_size: Vector3i = Vector3i.ONE) -> bool:
	if not grid_map:
		return false
	
	for x in range(building_size.x):
		for z in range(building_size.z):
			var check_pos = cell_pos + Vector3i(x, 0, z)
			var check_pos_vector3 = Vector3(check_pos.x, check_pos.y, check_pos.z)
			
			# Check bounds first
			if not is_position_in_bounds(check_pos_vector3):
				return false
				
			# Check if occupied
			if grid_map.get_cell_item(check_pos) != GridMap.INVALID_CELL_ITEM:
				return false
	return true

func get_grid_cell_from_mouse(mouse_pos: Vector2) -> Vector3i:
	var camera = get_viewport().get_camera_3d()
	if not camera or not grid_map:
		return Vector3i.ZERO
		
	var from = camera.project_ray_origin(mouse_pos)
	var to = from + camera.project_ray_normal(mouse_pos) * 1000
	
	var space_state = get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.create(from, to)
	var result = space_state.intersect_ray(query)
	
	if result:
		return grid_map.local_to_map(grid_map.to_local(result.position))
	
	# Fallback to ground plane
	var plane = Plane(Vector3.UP, 0)
	var intersection = plane.intersects_ray(from, to - from)
	if intersection:
		return grid_map.local_to_map(grid_map.to_local(intersection))
	
	return Vector3i.ZERO

# Call this if you change highlight_radius at runtime
func refresh_instances():
	create_instances()

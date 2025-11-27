class_name BuilderSystem
extends Node3D

@export var structures: Array[BuildingData] = []

var current_building_data: BuildingData
var selected_building_index:int = 0 


@export var selector:Node3D # The 'cursor'
@export var selector_container:Node3D # Node that holds a preview of the structure
@export var view_camera:Camera3D # Used for raycasting mouse
@export var gridmap:GridMap
@export var grid_highlight: GridHighlight
#bounds
@export var map_min_bounds: Vector3 = Vector3(-8,0,-8)
@export var map_max_bounds: Vector3 = Vector3(8,0,8)

#tooltip
@export var tooltip_label: Label # Add this to your UI scene

@onready var building_spawner: SceneSpawner = %BuildingSpawner
@onready var building_menu: SimpleBuildingMenu = $"../UI/BuildingMenu"
@onready var building_handler: Node3D = $"../BuildingHandler"

var tooltip_visible := false
var current_gridmap_position: Vector3
var building_mode_activated := false
var menu_mode_activated := false
var plane:Plane # Used for raycasting mouse



func _ready():
	
	plane = Plane(Vector3.UP, Vector3.ZERO)

	var mesh_library = MeshLibrary.new()
	
	for structure in structures:
		
		var id = mesh_library.get_last_unused_item_id()
		
		mesh_library.create_item(id)
		mesh_library.set_item_mesh(id, structure.model)
		mesh_library.set_item_mesh_transform(id, Transform3D())
		
	gridmap.mesh_library = mesh_library
	#selector_container.render_priority = 15
	if building_menu:
		building_menu.setup_buildings(structures)
		building_menu.building_selected.connect(_on_building_selected)
		building_menu.menu_closed.connect(_on_menu_closed)
		# Initialize with first building if available
	if structures.size() > 0:
		current_building_data = structures[0]
		update_structure()
	#update_cash()

func _process(delta):
	if menu_mode_activated:
		return
	action_rotate() # Rotates selection 90 degrees
	action_structure_toggle() # Toggles between structures
	var world_position = plane.intersects_ray(
		view_camera.project_ray_origin(get_viewport().get_mouse_position()),
		view_camera.project_ray_normal(get_viewport().get_mouse_position()))

	var gridmap_position = Vector3(round(world_position.x), 0, round(world_position.z))
	current_gridmap_position = gridmap_position
	# Building Mode
	if not building_mode_activated:
		selector.visible = false
		grid_highlight.visible = false
		hide_tooltip()
		return
	else:
		selector.visible = true
		grid_highlight.visible = true
		selector.position = lerp(selector.position, gridmap_position, delta * 40)
		grid_highlight.update_highlight_at_position(gridmap_position)
		update_building_preview(gridmap_position)
		action_build(gridmap_position)

func show_building_menu():
	menu_mode_activated = true
	building_mode_activated = false
	if building_menu:
		building_menu.show_menu()

func _on_building_selected(building_data: BuildingData):
	current_building_data = building_data
	# Find the index for backward compatibility with gridmap
	selected_building_index = structures.find(building_data)
	
	menu_mode_activated = false
	building_mode_activated = true
	update_structure()

func _on_menu_closed():
	menu_mode_activated = false
	# Don't automatically activate building mode when menu closes


func get_mesh(mesh: Mesh):         
	return mesh.duplicate()

# Check if a cell is occupied
func is_cell_occupied(gridmap_position: Vector3) -> bool:
	if not is_position_in_bounds(gridmap_position):
		return true
	var cell_item = gridmap.get_cell_item(gridmap_position)
	return cell_item != GridMap.INVALID_CELL_ITEM

# Update building preview based on whether cell is occupied
func update_building_preview(gridmap_position: Vector3):
	var out_of_bounds = not is_position_in_bounds(gridmap_position)
	var occupied = is_cell_occupied(gridmap_position)
	
	# Update preview material color
	for child in selector_container.get_children():
		if child is MeshInstance3D:
			var material = child.material_override as StandardMaterial3D
			if material:
				if out_of_bounds:
					material.albedo_color = Color(0.8, 0.8, 0.8, 0.3) 
				if occupied:
					material.albedo_color = Color(1, 0.3, 0.3, 0.6)  # Red tint for occupied
				else:
					material.albedo_color = Color(1, 1, 1, 0.6)     # Normal white for available
	
	## Update grid highlight color
	#if grid_highlight:
		#if occupied:
			#grid_highlight.set_color(Color.RED)
		#else:
			#grid_highlight.set_color(Color.GREEN)  # Assuming you have a set_color method
	#
	# Show/hide tooltip
	if out_of_bounds:
		show_tooltip("out of map boundaries!")
	elif occupied:
		show_tooltip("Cannot build here - cell occupied!")
	else:
		hide_tooltip()

func show_tooltip(text: String):
	if not tooltip_label:
		return
	tooltip_label.text = text
	tooltip_label.visible = true
	tooltip_visible = true
	
	# Position tooltip near mouse cursor
	var mouse_pos = get_viewport().get_mouse_position()
	
	tooltip_label.global_position = mouse_pos + Vector2(10, -30)

func hide_tooltip():
	if tooltip_label:
		tooltip_label.visible = false
		tooltip_visible = false

func action_build(gridmap_position):
	grid_highlight.activate()
	if Input.is_action_just_pressed("build"):
		if not is_position_in_bounds(gridmap_position):
			print("Cannot build - out of map boundaries!")
			return
		if is_cell_occupied(gridmap_position):
			print("Cannot build - cell is occupied!")
			# You could also play a sound effect here
			return
		gridmap.set_cell_item(gridmap_position, selected_building_index, gridmap.get_orthogonal_index_from_basis(selector.basis))
		var new_Building := building_spawner.spawn_scene(building_handler) as Building
		new_Building.global_position = gridmap_position #+# Vector3(0, - 0.2 ,0)
		new_Building.building_data = current_building_data
		new_Building.global_transform.basis = selector.global_transform.basis
		building_mode_activated = false
	

func action_rotate():
	if Input.is_action_just_pressed("rotate"):
		selector.rotate_y(deg_to_rad(90))
# Toggle between structures to build

# Keep these for backward compatibility / alternative input method
func action_structure_toggle():
	if Input.is_action_just_pressed("structure_next"):
		selected_building_index = wrap(selected_building_index + 1, 0, structures.size())
		current_building_data = structures[selected_building_index]
	if Input.is_action_just_pressed("structure_previous"):
		selected_building_index = wrap(selected_building_index - 1, 0, structures.size())
		current_building_data = structures[selected_building_index]
	update_structure()

func update_structure():
	if not current_building_data:
		return

	for n in selector_container.get_children():
		selector_container.remove_child(n)
		n.queue_free()

	var mesh_instance = MeshInstance3D.new()
	mesh_instance.mesh = current_building_data.model
	
	# Create and assign a transparent preview material
	var mat = StandardMaterial3D.new()
	mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	mat.flags_transparent = true
	mat.albedo_color = Color(1, 1, 1, 0.6)
	mat.render_priority = 11  # Render above grid highlight
	mesh_instance.material_override = mat

	selector_container.add_child(mesh_instance)
	mesh_instance.position.y += 1

# Optional: Method to clear a building (for demolition feature)
func clear_building_at_position(gridmap_position: Vector3):
	gridmap.set_cell_item(gridmap_position, GridMap.INVALID_CELL_ITEM)
	
	# Also remove the actual building instance
	for building in building_handler.get_children():
		if building.global_position.is_equal_approx(gridmap_position):
			building.queue_free()
			break

#bounds 
func is_position_in_bounds(gridmap_position: Vector3) -> bool:
	return (gridmap_position.x >= map_min_bounds.x and 
			gridmap_position.x <= map_max_bounds.x and
			gridmap_position.z >= map_min_bounds.z and 
			gridmap_position.z <= map_max_bounds.z)

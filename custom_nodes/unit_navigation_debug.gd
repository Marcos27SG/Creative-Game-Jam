class_name UnitNavigationDebug
extends Control
#
#@export var color: Color
#@export var path_colors: Array[Color]
#@export var game_area: PlayArea
##@export var unit_navigation: Node  # Reference to your UnitNavigation node
#
#var paths := {}
#var cell_size_2d: Vector2  # 2D representation of your 3D cell size
#
#
#func _ready() -> void:
	## Connect to the updated signal (now uses Vector2i)
	#UnitNavigation.astar_path_calculated.connect(_on_path_calculated)
	#
	## Set Control node to full screen for drawing
	#set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	#mouse_filter = Control.MOUSE_FILTER_IGNORE  # Don't block mouse input
#
#
#func _draw() -> void:
	## Check if unit_navigation and astar_grid are valid
	#if not UnitNavigation or not UnitNavigation.astar_grid:
		#return
	#
	## Get camera for 3D to 2D projection
	#var camera = get_viewport().get_camera_3d()
	#if not camera:
		#return
	#
	## Draw solid/occupied tiles
	#for i in UnitNavigation.astar_grid.region.size.x:
		#for j in UnitNavigation.astar_grid.region.size.y:
			#if UnitNavigation.astar_grid.is_point_solid(Vector2i(i, j)):
				## Convert grid coordinates to 3D world coordinates
				#var tile_pos = Vector2i(i, j)
				#var world_pos_3d = game_area.get_global_from_tile(tile_pos)
				#
				## Project 3D world position to 2D screen coordinates
				#var screen_pos = camera.unproject_position(world_pos_3d)
				#
				## Draw a small rectangle at the screen position
				#var rect_size = Vector2(20, 20)  # Adjust size as needed
				#draw_rect(Rect2(screen_pos - rect_size * 0.5, rect_size), color)
	#
	## Draw paths
	#var i := 0
	#for path in paths.values():
		#draw_path(path, path_colors[wrapi(i, 0, path_colors.size()-1)])
		#i += 1
	#
	## Draw p
#
#
#func _input(event: InputEvent) -> void:
	#if event.is_action_pressed("ui_accept"):
		#queue_redraw()
#
#
#func draw_path(points: Array[Vector2i], path_color: Color) -> void:
	#var camera = get_viewport().get_camera_3d()
	#if not camera:
		#return
		#
	#for i in range(1, points.size()):
		## Convert 2D tile coordinates to 3D world positions
		#var from_3d := game_area.get_global_from_tile(points[i-1])
		#var to_3d := game_area.get_global_from_tile(points[i])
		#
		## Project 3D positions to 2D screen coordinates
		#var from_2d := camera.unproject_position(from_3d)
		#var to_2d := camera.unproject_position(to_3d)
		#
		#draw_line(from_2d, to_2d, path_color, 3.0)  # Thicker line for visibility
		#
		## Optional: Draw arrows to show direction
		#_draw_arrow_head(from_2d, to_2d, path_color)
#
#
#func _draw_arrow_head(from: Vector2, to: Vector2, path_color: Color) -> void:
	#var direction = (to - from).normalized()
	#var arrow_size = 8.0
	#var arrow_angle = PI / 6  # 30 degrees
	#
	#var arrow_point1 = to - direction.rotated(arrow_angle) * arrow_size
	#var arrow_point2 = to - direction.rotated(-arrow_angle) * arrow_size
	#
	#draw_line(to, arrow_point1, path_color, 2.0)
	#draw_line(to, arrow_point2, path_color, 2.0)
#
#
#func _on_path_calculated(path: Array[Vector2i], unit: BattleUnit) -> void:
	#paths[unit] = path
	#queue_redraw()

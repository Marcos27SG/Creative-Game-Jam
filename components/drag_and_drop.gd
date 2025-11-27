class_name DragAndDrop3D
extends Node

signal drag_canceled(starting_position: Vector3)
signal drag_started
signal dropped(starting_position: Vector3)

@export var enabled: bool = true
@export var target: Area3D

@export var snap_grid_size: float = 0.0
@export var drag_plane_height: float = 0.0  # Height of the plane for dragging
@export var max_drag_distance: float = 100.0  # Max distance for ray casting

@onready var camera = get_viewport().get_camera_3d()

var starting_position: Vector3
var offset := Vector3.ZERO
var dragging := false
var drag_plane: Plane

func _ready() -> void:
	assert(target, "No target set for DragAndDrop3D Component!")
	target.input_event.connect(_on_target_input_event)

func _process(_delta: float) -> void:
	if dragging and target:
		# Update drag plane to be parallel to the camera's view plane at the object's height
		_update_drag_plane()
		
		var mouse_position = _get_mouse_position_in_3d()
		if mouse_position:
			var target_position = mouse_position + offset
			
			# Apply grid snapping if enabled
			if snap_grid_size > 0:
				target_position = Vector3(
					round(target_position.x / snap_grid_size) * snap_grid_size,
					target_position.y,
					round(target_position.z / snap_grid_size) * snap_grid_size
				)
			
			# Direct position setting for immediate response
			target.global_position = target_position

func _input(event: InputEvent) -> void:
	if dragging and event.is_action_pressed("cancel_drag"):
		_cancel_dragging()
	elif dragging and event.is_action_released("select"):  # Fixed: drop on release, not press
		_drop()

func _update_drag_plane() -> void:
	# Create a plane that's at the object's height but facing the camera
	var plane_normal = camera.global_transform.basis.z.normalized()
	var plane_point = Vector3(target.global_position.x, drag_plane_height, target.global_position.z)
	drag_plane = Plane(plane_normal, plane_normal.dot(plane_point))

func _get_mouse_position_in_3d() -> Vector3:
	if not camera:
		camera = get_viewport().get_camera_3d()
		if not camera:
			return Vector3.ZERO
	
	# Get mouse position and cast ray from camera
	var mouse_pos = get_viewport().get_mouse_position()
	var ray_origin = camera.project_ray_origin(mouse_pos)
	var ray_direction = camera.project_ray_normal(mouse_pos)
	
	# Ensure drag_plane is initialized
	if not dragging:
		_update_drag_plane()
	
	# Find intersection with drag plane
	var intersection = drag_plane.intersects_ray(ray_origin, ray_direction)
	
	# If no intersection found, try to find the closest point along the ray
	if not intersection:
		# Project the plane point onto the ray
		var plane_point = Vector3(target.global_position.x, drag_plane_height, target.global_position.z)
		var t = (plane_point - ray_origin).dot(ray_direction) / ray_direction.dot(ray_direction)
		t = clamp(t, 0, max_drag_distance)
		intersection = ray_origin + ray_direction * t
	
	return intersection

func _end_dragging() -> void:
	dragging = false
	target.remove_from_group("dragging")

func _cancel_dragging() -> void:
	_end_dragging()
	target.global_position = starting_position
	drag_canceled.emit(starting_position)

func _start_dragging() -> void:
	dragging = true
	starting_position = target.global_position
	target.add_to_group("dragging")
	
	# Initialize drag plane before getting mouse position
	_update_drag_plane()
	
	var mouse_pos = _get_mouse_position_in_3d()
	if mouse_pos:
		offset = target.global_position - mouse_pos
	
	drag_started.emit()

func _drop() -> void:
	if dragging:  # Only emit signal if we were actually dragging
		_end_dragging()
		dropped.emit(starting_position)

func _on_target_input_event(_camera: Node, event: InputEvent, _position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	if not enabled:
		return

	var dragging_object := get_tree().get_first_node_in_group("dragging")
	
	if not dragging and dragging_object and dragging_object != target:
		return
	
	if not dragging and event.is_action_pressed("select"):
		_start_dragging()

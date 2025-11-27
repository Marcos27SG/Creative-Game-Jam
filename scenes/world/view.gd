extends Node3D

@onready var camera_3d: Camera3D = $Camera3D

# Movement and Zoom Config
@export var movement_speed: float = 15.0
@export var zoom_speed: float = 1.0
@export var zoom_smoothness: float = 20.0
@export var move_smoothness: float = 8.0
@export var rotate_smoothness: float = 6.0

# Zoom Limits
@export var min_zoom: float = 4.0
@export var max_zoom: float = 12.0

# Position Bounds
@export var min_x_limit: float = -5.0
@export var max_x_limit: float = 5.0
@export var min_z_limit: float = -5.0
@export var max_z_limit: float = 5.0

# Internal state
var target_size: float
var camera_position: Vector3
var camera_rotation: Vector3

func _ready():
	camera_position = position
	camera_rotation = rotation_degrees
	target_size = camera_3d.size
	apply_position_limits()

func _process(delta):
	# Smooth transition to target position and rotation
	position = position.lerp(camera_position, move_smoothness * delta)
	rotation_degrees = rotation_degrees.lerp(camera_rotation, rotate_smoothness * delta)

	# Smooth zoom
	if abs(camera_3d.size - target_size) > 0.01:
		camera_3d.size = lerp(camera_3d.size, target_size, zoom_smoothness * delta)
	else:
		camera_3d.size = target_size

	handle_input(delta)

func handle_input(delta):
	var input_direction := Vector3.ZERO

	input_direction.x = Input.get_action_strength("camera_right") - Input.get_action_strength("camera_left")
	input_direction.z = Input.get_action_strength("camera_back") - Input.get_action_strength("camera_forward")

	if input_direction != Vector3.ZERO:
		# Rotate input to match camera's Y rotation (for isometric control)
		input_direction = input_direction.rotated(Vector3.UP, rotation.y).normalized()
		camera_position += input_direction * movement_speed * delta
		apply_position_limits()

	# Zoom input
	if Input.is_action_just_pressed("zoom_in_scroll"):
		target_size = max(target_size - zoom_speed, min_zoom)
	elif Input.is_action_just_pressed("zoom_out_scroll"):
		target_size = min(target_size + zoom_speed, max_zoom)

	# Reset to center if needed
	if Input.is_action_pressed("camera_center"):
		camera_position = Vector3.ZERO

func apply_position_limits():
	camera_position.x = clamp(camera_position.x, min_x_limit, max_x_limit)
	camera_position.z = clamp(camera_position.z, min_z_limit, max_z_limit)

func _input(event):
	if event is InputEventMouseMotion and Input.is_action_pressed("camera_rotate"):
		camera_rotation.y += -event.relative.x / 10.0  # Horizontal drag only

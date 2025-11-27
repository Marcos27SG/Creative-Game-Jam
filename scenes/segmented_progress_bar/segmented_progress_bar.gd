class_name RadialSegmentedProgressBar
extends Control

@export var total_segments: int = 3
@export var current_value: int = 4 : set = set_value
@export var filled_color: Color = Color.RED
@export var empty_color: Color = Color.DARK_GRAY
@export var segment_spacing_deg: float = 2.0
@export_range(0.0, 1.0, 0.01) var thickness_ratio: float = 0.25  # % of radius (0.25 = 25%)

func set_value(value: int):
	current_value = clamp(value, 0, total_segments)
	queue_redraw()

func _draw():
	if total_segments <= 0:
		return

	var center = size / 2
	var radius = min(size.x, size.y) / 2.0
	var inner_radius = radius * (1.0 - thickness_ratio)

	var total_angle = 360.0
	var segment_angle = (total_angle / total_segments) - segment_spacing_deg
	var angle_offset = -90.0  # start from top

	for i in range(total_segments):
		var start_angle_deg = i * (segment_angle + segment_spacing_deg) + angle_offset
		var end_angle_deg = start_angle_deg + segment_angle

		var is_filled = i < current_value
		var color = filled_color if is_filled else empty_color
		_draw_wedge(center, deg_to_rad(start_angle_deg), deg_to_rad(end_angle_deg), radius, inner_radius, color)

func _draw_wedge(center: Vector2, start_angle: float, end_angle: float, outer_r: float, inner_r: float, color: Color):
	var points := []
	var segments := 8  # number of segments to approximate curve

	# Outer arc points (clockwise)
	for i in range(segments + 1):
		var t = i / float(segments)
		var angle = lerp(start_angle, end_angle, t)
		var pos = center + Vector2(cos(angle), sin(angle)) * outer_r
		points.append(pos)

	# Inner arc points (counter-clockwise)
	for i in range(segments, -1, -1):
		var t = i / float(segments)
		var angle = lerp(start_angle, end_angle, t)
		var pos = center + Vector2(cos(angle), sin(angle)) * inner_r
		points.append(pos)

	draw_colored_polygon(points, color)

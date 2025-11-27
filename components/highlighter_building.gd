#class_name OutlineHighlighter
extends Node

@export var visuals: MeshInstance3D
@export var outline_color: Color
@export var highlight_color: Color

func initialize_highlight() -> void:
	if visuals:
		var base_material := visuals.get_active_material(0)

		# Ensure it's unique
		var unique_material := base_material.duplicate()
		visuals.set_surface_override_material(0, unique_material)
		var outline_material := unique_material as ShaderMaterial
		if outline_material:
			outline_material.set_shader_parameter("outline_intensity", 1)
			outline_material.set_shader_parameter("outline_color", outline_color)


func clear_highlight() -> void:
	var outline_material := visuals.get_active_material(0) as ShaderMaterial
	if outline_material:
		outline_material.set_shader_parameter("outline_intensity", 1)
		outline_material.set_shader_parameter("outline_color", outline_color)


func highlight() -> void:
	var outline_material := visuals.get_active_material(0) as ShaderMaterial

	if outline_material:
		outline_material.set_shader_parameter("outline_color", highlight_color)
		outline_material.set_shader_parameter("outline_intensity", 1)

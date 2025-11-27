class_name UnitAnimations
extends Node

const COMBINE_ANIM_LENGTH := 0.6
const COMBINE_ANIM_SCALE := Vector3(0.7, 0.7, 0.7)  # Uniform scaling in 3D
const COMBINE_ANIM_ALPHA := 0.5

@export var unit: Unit
# Reference to the MeshInstance3D (skin) for visual effects
@onready var skin: MeshInstance3D = unit.get_node("Skin") if unit else null

func play_combine_animation(target_position: Vector3) -> void:


	var tween := create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)

	unit.control_stats.hide()

	tween.tween_property(unit, "global_position", target_position, COMBINE_ANIM_LENGTH)
	tween.parallel().tween_property(unit, "scale", COMBINE_ANIM_SCALE, COMBINE_ANIM_LENGTH)
	var material = skin.get_surface_override_material(0)
	if not material:
		material = StandardMaterial3D.new()
		material.albedo_color = Color.WHITE
		skin.set_surface_override_material(0, material)
	#var shader_material := visuals.get_active_material(0) as ShaderMaterial
	if material:
		var start_alpha = material.get_shader_parameter("alpha")
		tween.parallel().tween_property(material, "shader_parameter/alpha", COMBINE_ANIM_ALPHA, COMBINE_ANIM_LENGTH).from(start_alpha)
		tween.tween_callback(unit.queue_free)

	#material.flags_transparent = true
	#var start_alpha = material.albedo_color.a
	#tween.parallel().tween_property(material, "albedo_color:a", COMBINE_ANIM_ALPHA, COMBINE_ANIM_LENGTH).from(start_alpha)
	#tween.tween_callback(unit.queue_free)

extends Node3D
#
#@export var target_mesh: Node3D
#@export var orbit_duration: float = 5.0
#@export var orbit_radius: float = 5.0
#
##var camera: Camera3D
#var tween: Tween
#@onready var camera: Camera3D = $Camera3D
#
#func _ready():
	#camera = $Camera3D  # Assuming camera is a child
	#if target_mesh:
		#global_position = target_mesh.global_position
		#start_orbit()
#
#func start_orbit():
	#tween = create_tween()
	#tween.set_loops()  # Infinite loop
	#tween.tween_method(update_orbit_position, 0.0, TAU, orbit_duration)
#
#func update_orbit_position(angle: float):
	#var x = cos(angle) * orbit_radius
	#var z = sin(angle) * orbit_radius
	#
	#camera.position = Vector3(x, camera.position.y, z)
	#camera.look_at(Vector3.ZERO, Vector3.UP)

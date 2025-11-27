class_name SellPortal
extends Area3D

@export var unit_pool: UnitPool
@export var player_stats: PlayerStats
@export var sell_sound: AudioStream
@onready var outline_highlighter: OutlineHighlighter = $OutlineHighlighter
@onready var control: Control = $Control



#@onready var outline_highlighter: OutlineHighlighter = $OutlineHighlighter
#@onready var gold: HBoxContainer = %Gold
#@onready var gold_label: Label = %GoldLabel
#@onready var gold: HBoxContainer = $Control/Gold
#@onready var gold_label: Label = $Control/Gold/GoldLabel
#
#var current_unit: Unit
#
#
#func _ready() -> void:
	#var units := get_tree().get_nodes_in_group("units")
	#for unit: Unit in units:
		#setup_unit(unit)
		##await ready
	#setup_control_nodes()
#
#
#func setup_control_nodes() -> void:
	#var camera = get_viewport().get_camera_3d()
	#var world_position = self.global_position
	#var screen_position: Vector2 = camera.unproject_position(world_position)
	#control.position = screen_position + Vector2(-20, 60)
	#print(control.position)
#
#func setup_unit(unit: Unit) -> void:
	#unit.drag_and_drop.dropped.connect(_on_unit_dropped.bind(unit))
	#unit.quick_sell_pressed.connect(_sell_unit.bind(unit))
#
#
#func _sell_unit(unit: Unit) -> void:
	#player_stats.gold += unit.stats.get_gold_value()
	## TODO give items back to item pool
	#unit_pool.add_unit(unit.stats)
	##print(unit_pool.unit_pool)
	#unit.queue_free()
	#SFXPlayer.play(sell_sound)
#
#
#func _on_unit_dropped(_starting_position: Vector3, unit: Unit) -> void:
	#if unit and unit == current_unit:
		#_sell_unit(unit)
#
#
#func _on_area_entered(unit: Unit) -> void:
	#current_unit = unit
	#outline_highlighter.highlight()
#
	#gold_label.text = str(unit.stats.get_gold_value())
	#gold.show()
	##setup_control_nodes()
#
#func _on_area_exited(unit: Unit) -> void:
	#if unit and unit == current_unit:
		#current_unit = null
	#
	#outline_highlighter.clear_highlight()
	#gold.hide()

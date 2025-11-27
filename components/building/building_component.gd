class_name BuildingComponent
extends Node

var owner_building: Building
var is_enabled: bool = true

func _init(building: Building) -> void:
	owner_building = building

func on_component_added() -> void:
	pass

func on_component_removed() -> void:
	pass

func set_enabled(enabled: bool) -> void:
	is_enabled = enabled

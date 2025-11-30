class_name ProductionComponent
extends Node

@export var consumption_data: Dictionary = {}
@export var production_data: Dictionary = {}
@export var production_interval: int = 1
@export var is_active: bool = true

var building: Building
var turns_since_last_production: int = 0

func _init(consume: Dictionary = {}, produce: Dictionary = {}, interval: int = 1) -> void:
	consumption_data = consume
	production_data = produce
	production_interval = interval
	name = "ProductionComponent"

func _ready() -> void:
	building = get_parent() as Building
	if building == null:
		push_error("ProductionComponent must be a child of Building!")
		return
	
	# Connect to turn manager
	if not TurnManager.turn_started.is_connected(_on_turn_started):
		TurnManager.turn_started.connect(_on_turn_started)
	
	print("ProductionComponent ready for building: ", building.building_data.name if building.building_data else "Unknown")

func _exit_tree() -> void:
	if TurnManager.turn_started.is_connected(_on_turn_started):
		TurnManager.turn_started.disconnect(_on_turn_started)

func _on_turn_started(_turn_number: int) -> void:
	turns_since_last_production += 1
	
	# Check if it's time to produce
	if turns_since_last_production >= production_interval:
		process_turn()
		turns_since_last_production = 0

func process_turn() -> void:
	if not is_active:
		return
	
	if building == null:
		return
	
	# First, check if we can afford consumption
	if not consumption_data.is_empty():
		if not VillageStats.can_afford_cost(consumption_data):
			_show_insufficient_resources()
			is_active = false  # Deactivate building if can't consume
			return
		
		# Consume resources
		VillageStats.subtract_resources(consumption_data)
		_show_consumption()
	
	# Then produce resources
	if not production_data.is_empty():
		VillageStats.add_resources(production_data)
		_show_production()
	
	is_active = true

func _show_production() -> void:
	if not building or not building.resource_produced or not building.timer_showing:
		return
		
	var text = "+"
	for resource in production_data:
		text += "%d %s " % [production_data[resource], resource.capitalize()]
	
	building.resource_produced.text = text
	building.resource_produced.modulate = Color.GREEN
	building.resource_produced.visible = true
	building.timer_showing.start()

func _show_consumption() -> void:
	if not building or not building.resource_produced or not building.timer_showing:
		return
		
	var text = "-"
	for resource in consumption_data:
		text += "%d %s " % [consumption_data[resource], resource.capitalize()]
	
	building.resource_produced.text = text
	building.resource_produced.modulate = Color.ORANGE
	building.resource_produced.visible = true
	building.timer_showing.start()

func _show_insufficient_resources() -> void:
	if not building or not building.resource_produced or not building.timer_showing:
		return
		
	building.resource_produced.text = "Insufficient Resources!"
	building.resource_produced.modulate = Color.RED
	building.resource_produced.visible = true
	building.timer_showing.start()

func get_status() -> String:
	if not is_active:
		return "INACTIVE - Insufficient Resources"
	
	if turns_since_last_production >= production_interval:
		return "Ready to produce"
	else:
		var turns_left = production_interval - turns_since_last_production
		return "Produces in %d turn(s)" % turns_left

# Debug info for inspector
func _get_configuration_warnings() -> PackedStringArray:
	var warnings: PackedStringArray = []
	
	if get_parent() == null or not get_parent() is Building:
		warnings.append("ProductionComponent should be a child of a Building node")
	
	if consumption_data.is_empty() and production_data.is_empty():
		warnings.append("No consumption or production data set")
	
	return warnings

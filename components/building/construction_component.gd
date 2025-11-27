# Construction component handles building construction
class_name ConstructionComponent
extends BuildingComponent

signal construction_completed
signal construction_progress_updated(turns_remaining: int)

var turns_to_complete: int = 0
var original_turns: int = 0
var is_constructed: bool = false

func _init(building: Building, construction_turns: int = 1) -> void:
	super(building)
	turns_to_complete = construction_turns
	original_turns = construction_turns

func on_component_added() -> void:
	TurnManager.turn_ended.connect(_on_turn_ended)

func on_component_removed() -> void:
	if TurnManager.turn_ended.is_connected(_on_turn_ended):
		TurnManager.turn_ended.disconnect(_on_turn_ended)

func _on_turn_ended(_turn_number: int) -> void:
	if not is_enabled or is_constructed:
		return
	
	turns_to_complete -= 1
	print("The building will be completed in: ", turns_to_complete)
	construction_progress_updated.emit(turns_to_complete)
	
	if turns_to_complete <= 0:
		_complete_construction()

func _complete_construction() -> void:
	is_constructed = true
	construction_completed.emit()
	print("Construction completed for: ", owner_building.building_data.name)

func get_construction_progress() -> float:
	if original_turns == 0:
		return 1.0
	return 1.0 - (float(turns_to_complete) / float(original_turns))

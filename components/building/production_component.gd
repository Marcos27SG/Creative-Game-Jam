# Production component for buildings that produce resources
class_name ProductionComponent
extends BuildingComponent

signal resource_produced(resource_type: String, amount: int)

var production_data: Dictionary = {}  # {"wood": 2, "energy_stacks": 1}
var production_interval: int = 1  # Every N turns
var turns_since_production: int = 0

func _init(building: Building, prod_data: Dictionary = {}, interval: int = 1) -> void:
	super(building)
	production_data = prod_data
	production_interval = interval

func on_component_added() -> void:
	TurnManager.turn_ended.connect(_on_turn_ended)

func on_component_removed() -> void:
	if TurnManager.turn_ended.is_connected(_on_turn_ended):
		TurnManager.turn_ended.disconnect(_on_turn_ended)

func _on_turn_ended(_turn_number: int) -> void:
	if not is_enabled or not _can_produce():
		return
	
	turns_since_production += 1
	
	if turns_since_production >= production_interval:
		_produce_resources()
		turns_since_production = 0

func _can_produce() -> bool:
	# Check if building is constructed and any other conditions
	var construction_comp = owner_building.get_component(ConstructionComponent)
	return construction_comp == null or construction_comp.is_constructed
	

func _produce_resources() -> void:
	print("llega a produce resources")
	
	for resource_type in production_data:
		var amount = production_data[resource_type]
		match resource_type:
			"wood":
				VillageStats.add_resources( "scrap" , amount)
			"energy_stacks":
				VillageStats.set_energy_stacks(VillageStats.energy_stacks + amount)
			"engine_life":
				VillageStats.set_engine_life(VillageStats.engine_life + amount)
		
		resource_produced.emit(resource_type, amount)
	print("resources produced: ", VillageStats)

class_name BuildingData
extends Resource

@export_subgroup("Identity")
@export var name: String = "Unknown Building"
@export var description: String = ""
@export var icon: Texture
@export var category: String = "General"

@export_subgroup("Model")
@export var model: Mesh

@export_subgroup("Construction")
@export var construction_cost: Dictionary = {} # {"scrap": 10, "energy": 5}

@export_subgroup("Production & Consumption")
## Resources this building consumes each turn (e.g., {"energy": 2, "food": 1})
@export var consumption_per_turn: Dictionary = {}
## Resources this building produces each turn (e.g., {"food": 3, "morale": 1})
@export var production_per_turn: Dictionary = {}
## How many turns between production cycles (1 = every turn)
@export var production_interval: int = 1

@export_subgroup("Placement")
@export var size: Vector2i = Vector2i(1, 1)

@export_subgroup("Rarity")
@export var rarity: Rarity = Rarity.COMMON

var pool_count = 1

# Building type enum
enum BuildingType {
	RESOURCE,
	PEOPLE,
	PRODUCTION,
	TROOP
}

enum Rarity {
	COMMON, 
	UNCOMMON, 
	RARE, 
	LEGENDARY
}

@export var building_type: BuildingType = BuildingType.RESOURCE

# Additional properties (kept for compatibility)
@export var population_capacity: int = 0

# Check if player can afford this building
func can_afford() -> bool:
	return VillageStats.can_afford_cost(construction_cost)

# Get a formatted string of what this building consumes
func get_consumption_string() -> String:
	if consumption_per_turn.is_empty():
		return "No consumption"
	
	var parts: Array[String] = []
	for resource in consumption_per_turn:
		parts.append("%d %s" % [consumption_per_turn[resource], resource.capitalize()])
	return " | ".join(parts)

# Get a formatted string of what this building produces
func get_production_string() -> String:
	if production_per_turn.is_empty():
		return "No production"
	
	var parts: Array[String] = []
	for resource in production_per_turn:
		parts.append("+%d %s" % [production_per_turn[resource], resource.capitalize()])
	return " | ".join(parts)

# Get construction cost as string
func get_cost_string() -> String:
	if construction_cost.is_empty():
		return "Free"
	
	var parts: Array[String] = []
	for resource in construction_cost:
		parts.append("%d %s" % [construction_cost[resource], resource.capitalize()])
	return " | ".join(parts)

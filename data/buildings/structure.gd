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
@export var construction_cost: Dictionary = {} # {"wood": 10, "energy_stacks": 5}
@export var construction_turns: int = 1

@export_subgroup("Production")
@export var production_data: Dictionary = {} # {"wood": 2} - produces 2 wood per turn
@export var production_interval: int = 1 # Every N turns

@export_subgroup("Placement")
@export var size: Vector2i = Vector2i(1, 1)

# Building type enum for better organization
enum BuildingType {
	RESOURCE,
	PEOPLE,
	PRODUCTION,
	TROOP
}

@export var building_type: BuildingType = BuildingType.RESOURCE

# Building size (for placement validation)
#@export var size: Vector2i = Vector2i(1, 1)

# Building effects/bonuses
@export var population_capacity: int = 0
@export var resource_generation: Dictionary = {} # e.g., {"wood": 2, "stone": 1}
@export var resource_consumption: Dictionary = {} # e.g., {"food": 1}

# Method to get total cost as string for display
#func get_cost_string() -> String:
	#var cost_parts: Array[String] = []
	#
	#if wood_cost > 0:
		#cost_parts.append(str(wood_cost) + " Wood")
	#if stone_cost > 0:
		#cost_parts.append(str(stone_cost) + " Stone")
	#if cost > 0:
		#cost_parts.append(str(cost) + " Gold")
	#
	#if cost_parts.is_empty():
		#return "Free"
	#
	#return ", ".join(cost_parts)

# Method to check if player can afford this building
func can_afford() -> bool:
	# Implement based on your resource system
	# Example:
	# return (VillageStats.wood >= wood_cost and 
	#         VillageStats.stone >= stone_cost and
	#         VillageStats.gold >= cost)
	return true # Placeholder

# Method to get category for tab organization
#func get_category() -> String:
	#if category.is_empty():
		#match building_type:
			#BuildingType.RESIDENTIAL:
				#return "Housing"
			#BuildingType.COMMERCIAL:
				#return "Commerce"
			#BuildingType.INDUSTRIAL:
				#return "Industry"
			#BuildingType.MILITARY:
				#return "Military"
			#BuildingType.DECORATION:
				#return "Decoration"
			#BuildingType.INFRASTRUCTURE:
				#return "Infrastructure"
			#_:
				#return "General"
	#return category

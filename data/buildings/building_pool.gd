class_name BuildingPool
extends Resource

@export var available_buildings: Array[BuildingData]

var building_pool: Array[BuildingData]


func generate_building_pool() -> void:
	building_pool = []
	
	for building: BuildingData in available_buildings:
		for i in building.pool_count:
			building_pool.append(building)


func get_random_unit_by_rarity(rarity: BuildingData.Rarity) -> BuildingData:
	var buildings := building_pool.filter(
		func(building: BuildingData):
			return building.rarity == rarity
	)
	
	if buildings.is_empty():
		return null
	
	var picked_unit: BuildingData = buildings.pick_random()
	building_pool.erase(picked_unit)
	
	return picked_unit


func add_unit(unit: BuildingData) -> void:
	#var combined_count := unit.get_combined_unit_count()
	unit = unit.duplicate()
	building_pool.append(unit)

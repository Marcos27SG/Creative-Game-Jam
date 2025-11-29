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
	
	# If no buildings of this rarity, try to get any building
	if buildings.is_empty():
		print("No buildings of rarity ", rarity, " available. Trying fallback...")
		return get_any_random_unit()
	
	var picked_unit: BuildingData = buildings.pick_random()
	building_pool.erase(picked_unit)
	
	return picked_unit

func get_any_random_unit() -> BuildingData:
	if building_pool.is_empty():
		push_error("Building pool is completely empty!")
		return null
	
	var picked_unit: BuildingData = building_pool.pick_random()
	building_pool.erase(picked_unit)
	return picked_unit

func add_unit(unit: BuildingData) -> void:
	if unit == null:
		return
	unit = unit.duplicate()
	building_pool.append(unit)
	
func remove_unit(unit: BuildingData) -> void:
	if unit == null:
		return
	# Remove from the main pool, not available_buildings
	if building_pool.has(unit):
		building_pool.erase(unit)

func get_pool_size() -> int:
	return building_pool.size()

func get_buildings_by_rarity(rarity: BuildingData.Rarity) -> int:
	return building_pool.filter(func(b): return b.rarity == rarity).size()

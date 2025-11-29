extends Node

signal resource_changed(resource_type: String, old_value: int, new_value: int)
#signal wood_changed
signal resources_changed

var population_energy := 30 : set = set_population_energy
var turns_per_day :=3
var engine_life := 50 : set = set_engine_life
#var stone : int = 100
# Resources
var crystal := 0 #: set = set_crystal
var scrap := 100
var stone := 100
var battery := 0

#Population

const ROLL_RARITIES := {
	1:  [BuildingData.Rarity.COMMON],
	2:  [BuildingData.Rarity.COMMON, BuildingData.Rarity.UNCOMMON],
	3:  [BuildingData.Rarity.COMMON, BuildingData.Rarity.UNCOMMON],
	4:  [BuildingData.Rarity.COMMON, BuildingData.Rarity.UNCOMMON, BuildingData.Rarity.RARE],
	5:  [BuildingData.Rarity.COMMON, BuildingData.Rarity.UNCOMMON, BuildingData.Rarity.RARE],
	6:  [BuildingData.Rarity.COMMON, BuildingData.Rarity.UNCOMMON, BuildingData.Rarity.RARE],
	7:  [BuildingData.Rarity.COMMON, BuildingData.Rarity.UNCOMMON, BuildingData.Rarity.RARE, BuildingData.Rarity.LEGENDARY],
	8:  [BuildingData.Rarity.COMMON, BuildingData.Rarity.UNCOMMON, BuildingData.Rarity.RARE, BuildingData.Rarity.LEGENDARY],
	9:  [BuildingData.Rarity.COMMON, BuildingData.Rarity.UNCOMMON, BuildingData.Rarity.RARE, BuildingData.Rarity.LEGENDARY],
	10: [BuildingData.Rarity.COMMON, BuildingData.Rarity.UNCOMMON, BuildingData.Rarity.RARE, BuildingData.Rarity.LEGENDARY],
}

const ROLL_CHANCES := {
	1: [1.0],                        # 1 rarity = 1 weight
	2: [7.5, 2.5],                   # 2 rarities = 2 weights
	3: [7.5, 2.5],                   # 2 rarities = 2 weights
	4: [6.5, 3.0, 0.5],              # 3 rarities = 3 weights
	5: [5.0, 3.5, 1.5],              # 3 rarities = 3 weights
	6: [4.0, 4.0, 2.0],              # 3 rarities = 3 weights
	7: [2.75, 4.0, 3.24, 0.1],       # 4 rarities = 4 weights ✓
	8: [2.5, 3.75, 3.45, 0.3],       # 4 rarities = 4 weights ✓
	9: [1.75, 2.75, 4.5, 1.0],       # 4 rarities = 4 weights ✓
	10: [1.0, 2.0, 4.5, 2.5],        # 4 rarities = 4 weights ✓
}

func set_population_energy(value: int) -> void:
	var old_value = population_energy
	population_energy = max(0, value)
	if old_value != population_energy:
		resource_changed.emit("population_energy", old_value, population_energy)

#func set_crystal(value: int) -> void:
	#var old_value = crystal
	#crystal = max(0, value)
	#if old_value != crystal:
		#wood_changed.emit()

func set_engine_life(value: int) -> void:
	var old_value = engine_life
	engine_life = max(0, value)
	if old_value != engine_life:
		resource_changed.emit("engine_life", old_value, engine_life)

func can_afford_cost(cost_data: Dictionary) -> bool:
	for resource_type in cost_data:
		match resource_type:
			"population_energy":
				if population_energy < cost_data[resource_type]:
					return false
			"wood":
				if crystal < cost_data[resource_type]:
					return false
			"engine_life":
				if engine_life < cost_data[resource_type]:
					return false
	return true

#func spend_resources(cost_data: Dictionary) -> bool:
	#if not can_afford_cost(cost_data):
		#return false
	#
	#for resource_type in cost_data:
		#match resource_type:
			#"energy_stacks":
				#set_population_energy(population_energy - cost_data[resource_type])
			#"wood":
				#set_crystal(crystal - cost_data[resource_type])
			#"engine_life":
				#set_engine_life(engine_life - cost_data[resource_type])
	#
	#return true

func substract_resources(resource: String , amount: int) -> void:
	self[resource] -= amount
	resources_changed.emit()
	
func add_resources(resource: String , amount: int) -> void:
	self[resource] += amount
	resources_changed.emit()
	
func get_random_rarity_for_level() -> BuildingData.Rarity:
	var rng = RandomNumberGenerator.new()
	var day = clamp(TurnManager.current_day, 1, 10)
	var array: Array = ROLL_RARITIES[day]
	var weights: PackedFloat32Array = PackedFloat32Array(ROLL_CHANCES[day])
	
	# Safety check
	if weights.size() != array.size():
		push_error("Mismatch between rarities and weights for day " + str(day))
		return BuildingData.Rarity.COMMON
	
	return array[rng.rand_weighted(weights)]

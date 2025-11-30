extends Node

signal resource_changed(resource_type: String, old_value: int, new_value: int)
signal resources_changed

# Core Resources
var energy := 50 : set = set_energy
var morale := 50 : set = set_morale
var food := 30 : set = set_food
var scrap := 100 : set = set_scrap

# Additional Resources (keeping your existing ones)
var crystal := 0
var stone := 100
var battery := 0

# Game Settings
var turns_per_day := 3

# Valid resource names for validation
const VALID_RESOURCES := ["energy", "morale", "food", "scrap", "crystal", "stone", "battery"]

# Rarity system for building rolls
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
	1: [1.0],
	2: [7.5, 2.5],
	3: [7.5, 2.5],
	4: [6.5, 3.0, 0.5],
	5: [5.0, 3.5, 1.5],
	6: [4.0, 4.0, 2.0],
	7: [2.75, 4.0, 3.24, 0.1],
	8: [2.5, 3.75, 3.45, 0.3],
	9: [1.75, 2.75, 4.5, 1.0],
	10: [1.0, 2.0, 4.5, 2.5],
}

# Setters for resource tracking
func set_energy(value: int) -> void:
	var old_value = energy
	energy = max(0, value)
	if old_value != energy:
		resource_changed.emit("energy", old_value, energy)
		resources_changed.emit()

func set_morale(value: int) -> void:
	var old_value = morale
	morale = max(0, value)
	if old_value != morale:
		resource_changed.emit("morale", old_value, morale)
		resources_changed.emit()

func set_food(value: int) -> void:
	var old_value = food
	food = max(0, value)
	if old_value != food:
		resource_changed.emit("food", old_value, food)
		resources_changed.emit()

func set_scrap(value: int) -> void:
	var old_value = scrap
	scrap = max(0, value)
	if old_value != scrap:
		resource_changed.emit("scrap", old_value, scrap)
		resources_changed.emit()

# Check if resource exists
func has_resource(resource_name: String) -> bool:
	return resource_name in VALID_RESOURCES

# Get resource value by name
func get_resource_value(resource_name: String) -> int:
	match resource_name:
		"energy": return energy
		"morale": return morale
		"food": return food
		"scrap": return scrap
		"crystal": return crystal
		"stone": return stone
		"battery": return battery
		_:
			push_warning("Unknown resource: " + resource_name)
			return 0

# Set resource value by name
func set_resource_value(resource_name: String, value: int) -> void:
	match resource_name:
		"energy": set_energy(value)
		"morale": set_morale(value)
		"food": set_food(value)
		"scrap": set_scrap(value)
		"crystal": crystal = value
		"stone": stone = value
		"battery": battery = value
		_:
			push_warning("Unknown resource: " + resource_name)

# Check if player can afford a cost
func can_afford_cost(cost_data: Dictionary) -> bool:
	for resource_type in cost_data:
		var amount = cost_data[resource_type]
		if not has_resource(resource_type):
			push_warning("Unknown resource type: " + resource_type)
			return false
		if get_resource_value(resource_type) < amount:
			return false
	return true

# Subtract resources (for costs)
func subtract_resources(cost_data: Dictionary) -> bool:
	if not can_afford_cost(cost_data):
		return false
	
	for resource_type in cost_data:
		var amount = cost_data[resource_type]
		var current = get_resource_value(resource_type)
		set_resource_value(resource_type, current - amount)
	
	return true

# Add resources (for production)
func add_resources(production_data: Dictionary) -> void:
	for resource_type in production_data:
		var amount = production_data[resource_type]
		if has_resource(resource_type):
			var current = get_resource_value(resource_type)
			set_resource_value(resource_type, current + amount)
		else:
			push_warning("Unknown resource type: " + resource_type)

# Get random rarity based on current day
func get_random_rarity_for_level() -> BuildingData.Rarity:
	var rng = RandomNumberGenerator.new()
	var day = clamp(TurnManager.current_day, 1, 10)
	var array: Array = ROLL_RARITIES[day]
	var weights: PackedFloat32Array = PackedFloat32Array(ROLL_CHANCES[day])
	
	if weights.size() != array.size():
		push_error("Mismatch between rarities and weights for day " + str(day))
		return BuildingData.Rarity.COMMON
	
	return array[rng.rand_weighted(weights)]

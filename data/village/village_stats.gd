extends Node

signal resource_changed(resource_type: String, old_value: int, new_value: int)
#signal wood_changed
signal resources_changed

var population_energy := 30 : set = set_population_energy
var turns_per_day := 6
var engine_life := 50 : set = set_engine_life
#var stone : int = 100
# Resources
var crystal := 0 #: set = set_crystal
var scrap := 100
var stone := 100
var battery := 0

#Population

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

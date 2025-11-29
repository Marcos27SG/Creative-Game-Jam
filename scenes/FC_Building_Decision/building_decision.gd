class_name BuildingDecision
extends VBoxContainer

signal building_bought (building: BuildingData)

@export var building_pool : BuildingPool
@onready var shop_buildings: HBoxContainer = $ShopBuildings
@onready var scene_spawner: SceneSpawner = $SceneSpawner

func _ready() -> void:
	building_pool.generate_building_pool()
	
	for child: Node in shop_buildings.get_children():
		child.queue_free()

	Events.choiceBuildingEvent.connect(_on_update_new_turn)
	_roll_units()

func _roll_units() -> void:
	self.show()
	
	# Check if we have enough buildings
	if building_pool.get_pool_size() < 3:
		push_error("Not enough buildings in pool! Only " + str(building_pool.get_pool_size()) + " remaining.")
		# You might want to end the game or handle this differently
		return
	
	for i in 3:
		var rarity := VillageStats.get_random_rarity_for_level()
		var new_card := scene_spawner.spawn_scene(shop_buildings) as BuildingCardShop
		var building := building_pool.get_random_unit_by_rarity(rarity)
		
		if building == null:
			push_error("Failed to get building for turn!")
			new_card.queue_free()
			continue
		
		new_card.building_stats = building
		new_card.building_bought.connect(_on_unit_bought)

func _on_unit_bought(unit: BuildingData) -> void:
	self.hide()
	building_bought.emit(unit)
	
	# Remove the bought building from the pool immediately
	building_pool.remove_unit(unit)
	print("Removed from pool: ", unit.name)
	
	# Put back the remaining buildings
	_put_back_remaining_to_pool(unit)

func _on_update_new_turn() -> void:
	_put_back_remaining_to_pool()
	_roll_units()

func _put_back_remaining_to_pool(exclude_unit: BuildingData = null) -> void:
	for building_card: BuildingCardShop in shop_buildings.get_children():
		# Don't add back the building that was just bought
		if building_card.building_stats != exclude_unit:
			building_pool.add_unit(building_card.building_stats)
			#print("Added back: ", building_card.building_stats.name)
		
		building_card.queue_free()
	
	#print("Pool size: ", building_pool.available_buildings.size())

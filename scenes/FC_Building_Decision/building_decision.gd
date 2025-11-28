class_name BuildingDecision
extends VBoxContainer

signal building_bought (building: BuildingData)


@export var building_pool : BuildingPool
#@export var village_stats : VillageStats
@onready var shop_buildings: HBoxContainer = $ShopBuildings
@onready var scene_spawner: SceneSpawner = $SceneSpawner



func _ready() -> void:
	building_pool.generate_building_pool()
	
	for child: Node in shop_buildings.get_children():
		child.queue_free()

	_roll_units()


func _roll_units() -> void:
	for i in 3:
		var rarity := VillageStats.get_random_rarity_for_level()
		var new_card := scene_spawner.spawn_scene(shop_buildings) as BuildingCardShop
		new_card.building_stats = building_pool.get_random_unit_by_rarity(rarity)
		new_card.building_bought.connect(_on_unit_bought)


func _on_unit_bought(unit: BuildingData) -> void:
	self.hide()
	building_bought.emit(unit)
	
	

class_name BuildingCardShop
extends Control

signal building_bought (building: BuildingData)
@onready var logo: TextureRect = $VBoxContainer/Logo
@onready var description: RichTextLabel = $VBoxContainer/Description
@onready var building_name: Label = $VBoxContainer/building_name

@export var village_stats: VillageStats

@export var building_stats: BuildingData : set = _set_building_stats
var bought := false

func _set_building_stats(value: BuildingData) -> void:
	building_stats = value
	
	building_name.text = building_stats.name
	logo.texture = building_stats.icon
	description.text = building_stats.description
	


func _on_select_building_pressed() -> void:
	bought = true
	building_bought.emit(building_stats)
	

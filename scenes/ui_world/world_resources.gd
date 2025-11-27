class_name WorldResources
extends HBoxContainer

@onready var crystal_text: Label = $CrystalText
@onready var scrap_text: Label = $ScrapText
@onready var battery_text: Label = $BatteryText

func _ready() -> void:
	update_resources()
	VillageStats.resources_changed.connect(update_resources)
	
func update_resources() -> void:
	crystal_text.text = str(VillageStats.crystal)
	scrap_text.text = str(VillageStats.scrap)
	battery_text.text = str(VillageStats.battery)

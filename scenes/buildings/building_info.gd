class_name BuildingInfo
extends Panel
@onready var building_name: Label = $VBoxContainer/BuildingName
@onready var building_icon: TextureRect = $VBoxContainer/BuildingIcon
@onready var building_description: RichTextLabel = $VBoxContainer/Panel/Building_Description


func _ready() -> void:
	visible = false
	GameEvents.building_clicked.connect(setup)

func setup(building :BuildingData) -> void:
	visible = true
	building_name.text = building.name
	building_icon.texture = building.icon
	building_description.text = building.description
	
func _on_button_pressed() -> void:
	visible = false

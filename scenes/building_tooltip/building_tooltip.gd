class_name ItemTraitTooltip
extends VBoxContainer

#@onready var popup_icon: TextureRect = %PopupIcon
#@onready var popup_title: Label = %PopupTitle
#@onready var popup_description: RichTextLabel = %PopupDescription
@onready var type_icon: TextureRect = %TypeIcon
@onready var building_title: Label = %BuildingTitle
@onready var building_description: RichTextLabel = %BuildingDescription

var building_data: ItemTraitTooltipData


func _ready() -> void:
	if not building_data:
		return

	type_icon.texture = building_data.icon
	building_title.text = building_data.name
	building_description.text = building_data.description
	building_description.custom_minimum_size.x = building_data.min_size_x


func setup(icon: Texture , title: String, description: String, min_x: float = 0.0) -> void:
	building_data = ItemTraitTooltipData.new()
	building_data.icon = icon
	building_data.name = title
	building_data.description = description
	building_data.min_size_x = min_x

# TODO check order --> where should this go?
# or we can just delete this lol
class ItemTraitTooltipData:
	var icon: Texture
	var name: String
	var description: String
	var min_size_x: float

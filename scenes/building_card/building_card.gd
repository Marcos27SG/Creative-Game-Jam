class_name BuildingCard
extends Button

signal building_selected(building_data: BuildingData)

@export var building_data: BuildingData : set = set_building_data

@onready var cost_label: Label = %GoldCost
@onready var building_name: Label = %BuildingName
@onready var building_icon: TextureRect = %UnitIcon


var built := false

func _ready() -> void:
	# Connect button press
	pressed.connect(_on_pressed)
	
	# Set basic button properties
	size_flags_horizontal = Control.SIZE_EXPAND_FILL
	custom_minimum_size = Vector2(120, 80)
	
	update_display()

func set_building_data(value: BuildingData) -> void:
	building_data = value
	if is_inside_tree():
		update_display()

func update_display() -> void:
	if not building_data:
		return
	
	# Update building name
	if building_name:
		building_name.text = building_data.name if building_data.name else "Unknown"
	
	# Update cost
	#if cost_label:
		#var cost_text = "Free"
		#if building_data.has_method("get_cost"):
			#cost_text = str(building_data.get_cost())
		#elif "cost" in building_data:
			#cost_text = str(building_data.cost)
		#cost_label.text = cost_text
	#cost_label.text =  str(building_data.construction_turns)
	
	# Update icon
	if building_icon and "icon" in building_data and building_data.icon:
		building_icon.texture = building_data.icon

func _on_pressed() -> void:
	if built:
		return
	
	print("Building selected: ", building_data.name if building_data else "Unknown")
	building_selected.emit(building_data)
	
	# Simple visual feedback
	#built = true
	#modulate = Color.GRAY

func reset_card() -> void:
	built = false
	modulate = Color.WHITE
	


func _on_mouse_entered() -> void:
	TooltipHandler.popup.show_popup(
	_get_trait_tooltip(),
	get_global_mouse_position()
		)

func _get_trait_tooltip() -> ItemTraitTooltip:
	var new_tooltip := TooltipHandler.ITEM_TRAIT_TOOLTIP.instantiate() as ItemTraitTooltip
	new_tooltip.setup(
		building_data.icon,
		building_data.name,
		building_data.description,
		200.0
	)
	return new_tooltip




func _on_mouse_exited() -> void:
	TooltipHandler.popup.hide_popup()

class_name SimpleBuildingMenu
extends Control

signal building_selected(building_data: BuildingData)
signal menu_closed()

# Node references
@export var close_button: Button
@export var card_container: HBoxContainer 
@export var tab_container: HBoxContainer  # Container for tab buttons

var building_card_scene = preload("res://scenes/building_card/building_card.tscn")

# Tab system
var tab_buttons: Array[Button] = []
var current_tab: BuildingData.BuildingType = BuildingData.BuildingType.RESOURCE
var all_buildings: Array[BuildingData] = []

# Tab configuration - you can easily add more types here
var tab_config = {
	BuildingData.BuildingType.RESOURCE: {
		"label": "Resources",
		"color": Color.GREEN
	},
	BuildingData.BuildingType.PEOPLE: {
		"label": "People", 
		"color": Color.BLUE
	},
	BuildingData.BuildingType.PRODUCTION: {
		"label": "Production",
		"color": Color.ORANGE
	},
	BuildingData.BuildingType.TROOP: {
		"label": "Military",
		"color": Color.RED
	}
}

func _ready() -> void:
	if close_button:
		close_button.pressed.connect(_on_close_pressed)
	
	visible = false
	_setup_tabs()

func _setup_tabs() -> void:
	if not tab_container:
		print("Warning: tab_container not assigned")
		return
	
	# Clear existing tabs
	for child in tab_container.get_children():
		child.queue_free()
	
	tab_buttons.clear()
	
	# Create tab buttons for each building type
	for building_type in tab_config.keys():
		var tab_button = Button.new()
		tab_button.text = tab_config[building_type]["label"]
		tab_button.toggle_mode = true
		tab_button.button_group = ButtonGroup.new() if tab_buttons.is_empty() else tab_buttons[0].button_group
		
		# Style the button (optional)
		var style_box = StyleBoxFlat.new()
		style_box.bg_color = tab_config[building_type]["color"]
		style_box.corner_radius_top_left = 5
		style_box.corner_radius_top_right = 5
		tab_button.add_theme_stylebox_override("pressed", style_box)
		
		tab_button.pressed.connect(_on_tab_selected.bind(building_type))
		tab_container.add_child(tab_button)
		tab_buttons.append(tab_button)
	
	# Select first tab by default
	if not tab_buttons.is_empty():
		tab_buttons[0].button_pressed = true

func setup_buildings(buildings: Array[BuildingData]) -> void:
	print("Setting up buildings...")
	all_buildings = buildings
	
	# Update tabs visibility based on available buildings
	_update_tab_visibility()
	
	# Show buildings for current tab
	_show_buildings_for_current_tab()

func _update_tab_visibility() -> void:
	# Hide tabs that have no buildings
	var available_types = {}
	for building in all_buildings:
		available_types[building.building_type] = true
	
	for i in range(tab_buttons.size()):
		var building_type = tab_config.keys()[i]
		tab_buttons[i].visible = available_types.has(building_type)

func _show_buildings_for_current_tab() -> void:
	_clear_building_cards()
	
	# Filter buildings by current tab
	var filtered_buildings = all_buildings.filter(func(building): return building.building_type == current_tab)
	
	# Create cards for filtered buildings
	for building in filtered_buildings:
		var building_card = _create_building_card(building)
		if building_card:
			card_container.add_child(building_card)
	
	print("Showing ", filtered_buildings.size(), " buildings for tab: ", tab_config[current_tab]["label"])

func _on_tab_selected(building_type: BuildingData.BuildingType) -> void:
	current_tab = building_type
	_show_buildings_for_current_tab()

func _clear_building_cards() -> void:
	if not card_container:
		return
		
	for child in card_container.get_children():
		child.queue_free()

func _create_building_card(building_data: BuildingData) -> BuildingCard:
	var building_card: BuildingCard
	
	if building_card_scene:
		building_card = building_card_scene.instantiate()
	#else:
		## Fallback: create card directly
		#building_card = BuildingCard.new()
	
	if building_card:
		building_card.building_data = building_data
		building_card.building_selected.connect(_on_building_card_selected)
		
		# Prevent cards from expanding to fill container
		#building_card.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
		#building_card.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	
	return building_card

func _on_building_card_selected(building_data: BuildingData) -> void:
	print("Building selected: ", building_data.name)
	building_selected.emit(building_data)
	hide_menu()

func show_menu() -> void:
	visible = true
	print("Building menu shown")

func hide_menu() -> void:
	visible = false
	menu_closed.emit()
	print("Building menu hidden")

func _on_close_pressed() -> void:
	hide_menu()

func _input(event: InputEvent) -> void:
	if visible and event.is_action_pressed("ui_cancel"):
		hide_menu()
		get_viewport().set_input_as_handled()

# Helper function to add new building types dynamically
func add_building_type(type: BuildingData.BuildingType, label: String, color: Color = Color.WHITE) -> void:
	tab_config[type] = {
		"label": label,
		"color": color
	}
	_setup_tabs()
	_update_tab_visibility()

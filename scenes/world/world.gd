class_name World
extends Node3D
#@onready var grass: MultiMeshInstance3D = $Grass
@onready var builder: BuilderSystem = $Builder
#@onready var man_power_bar: SegmentedProgressBar = $ManPowerBar
#@onready var skill_manager: Control = $UI/SkillManager
@onready var turn_bar: RadialSegmentedProgressBar = $UI/TurnBar


enum ClickMode {NONE, BUILD}
@onready var next_turn: Button = $UI/NextTurn

#@onready var next_turn: Button = $NextTurn
@export var turns_per_day : int = VillageStats.turns_per_day
var click_mode := ClickMode.NONE
#@onready var wood: Label = $Wood
#@onready var wood: Label = $UI/Wood
@onready var building_decision: BuildingDecision = $UI/BuildingDecision

# Run Manager Access
@onready var world_ui: CanvasLayer = $UI
@onready var world_camera_3d: Camera3D = $View/Camera3D


var buildings: Array[Building] = []

func _ready() -> void:
	
	_setup_turn_system()
	_setup_ui()
	building_decision.building_bought.connect(builder.add_to_structures)
	
	#_update_label()
	#VillageStats.wood_changed.connect(_update_label)
	
#
#func _update_label() -> void:
	#wood.text = str(VillageStats.wood)

func _setup_turn_system() -> void:
	# Initialize TurnManager
	pass
	#Test NewIdea
	#TurnManager.turns_per_day = turns_per_day
	TurnManager.turn_ended.connect(_on_turn_ended)
	#TurnManager.day_ended.connect(_on_day_ended)

func _setup_ui() -> void:
	turn_bar.total_segments = turns_per_day
	turn_bar.current_value = TurnManager.get_turns_remaining_in_day()


func _on_build_button_pressed() -> void:
	builder.show_building_menu()
	#uilder.building_mode_activated = true
	
# Optional: Add ESC key handling to close menus
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		if builder.menu_mode_activated:
			builder._on_menu_closed()
		elif builder.building_mode_activated:
			builder.building_mode_activated = false

func _on_next_turn_pressed() -> void:
	var remaining_turns = TurnManager.get_turns_remaining_in_day()
	if remaining_turns <= 0:
		return
	
	TurnManager.advance_turn()

func _on_turn_ended(_turn_number: int) -> void:
	_update_turn_ui()

func _on_day_ended(_day_number: int) -> void:
	_reset_daily_resources()

func _update_turn_ui() -> void:
	var remaining_turns = TurnManager.get_turns_remaining_in_day()
	turn_bar.current_value = remaining_turns
	next_turn.disabled = remaining_turns <= 0

func _reset_daily_resources() -> void:
	# Reset daily resources here
	turn_bar.current_value = turns_per_day
	next_turn.disabled = false

func add_building(building: Building) -> void:
	buildings.append(building)
	add_child(building)

func remove_building(building: Building) -> void:
	buildings.erase(building)
	building.queue_free()

#
#func _on_skill_tree_pressed() -> void:
	
#	skill_manager.show()

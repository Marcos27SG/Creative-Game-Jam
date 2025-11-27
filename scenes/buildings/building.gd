class_name Building
extends Node3D

#signal building_constructed
#signal building_destroyed
@onready var highlighter: OutlineHighlighter = $Highlighter

@export var building_data: BuildingData : set = setup
@onready var meshBuilding: MeshInstance3D = $MeshInstance3D
#@onready var label: Label = $Label
#Resource
@onready var resource_produced: Label = $ResourceProduced
@onready var timer_showing: Timer = $ResourceProduced/TimerShowing

var stats 
var components: Dictionary = {}
var grid_position: Vector2i

func _ready() -> void:
	if building_data == null:
		return
	_initialize_building(building_data)
	
func _process(_delta: float) -> void:
	# Stats following the unit
	var camera = get_viewport().get_camera_3d()
	#var camera = camera_3d
	var world_position = self.global_position
	var screen_position: Vector2 = camera.unproject_position(world_position)
	#Label.position = screen_position + Vector2(-40 , -90)
	

func _initialize_building(building_info) -> void:
	print("initialize building")
	if building_info.construction_turns > 0:
		print("test constr comp")
		add_component (ConstructionComponent.new(self, building_info.construction_turns))
	# Add production component if building produces resources
	if not building_info.production_data.is_empty():
		add_component(ProductionComponent.new(self, building_info.production_data, building_info.production_interval))

func add_component(component: BuildingComponent) -> void:
	var component_type = component.get_script()
	if component_type in components:
		push_warning("Component of type %s already exists. Replacing..." % component_type)
		remove_component(component_type)
	#add_child(component)
	components[component_type] = component
	component.on_component_added()

func remove_component(component_type) -> void:
	if component_type in components:
		components[component_type].on_component_removed()
		components.erase(component_type)

func get_component(component_type) -> BuildingComponent:
	return components.get(component_type)

func has_component(component_type) -> bool:
	return component_type in components

func is_constructed() -> bool:
	var construction_comp = get_component(ConstructionComponent)
	return construction_comp == null or construction_comp.is_constructed

func get_construction_progress() -> float:
	var construction_comp = get_component(ConstructionComponent)
	if construction_comp == null:
		return 1.0
	return construction_comp.get_construction_progress()
func setup(data: BuildingData):
	if not is_node_ready():
		await ready
	meshBuilding.mesh = data.model
	_initialize_building(data)
	building_data = data

func _on_input_event(_camera: Node, event: InputEvent, _event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	if event.is_action_pressed("select"):
		GameEvents.building_clicked.emit(building_data)
		print("price",building_data.name)
		#highlighter.highlight()


func _on_mouse_entered() -> void:
	highlighter.highlight()



func _on_mouse_exited() -> void:
	highlighter.clear_highlight()

class_name Building
extends Node3D

@onready var highlighter: OutlineHighlighter = $Highlighter
@export var building_data: BuildingData : set = setup
@onready var meshBuilding: MeshInstance3D = $MeshInstance3D
@onready var resource_produced: Label = $ResourceProduced
@onready var timer_showing: Timer = $ResourceProduced/TimerShowing

var stats 
var grid_position: Vector2i

func _ready() -> void:
	if building_data == null:
		return
	_initialize_building(building_data)
	
	# Connect timer to hide label
	if timer_showing:
		timer_showing.timeout.connect(_on_timer_showing_timeout)

func _process(_delta: float) -> void:
	# Keep UI following the building
	var camera = get_viewport().get_camera_3d()
	if camera and resource_produced:
		var world_position = self.global_position
		var screen_position: Vector2 = camera.unproject_position(world_position)
		# Adjust offset as needed
		resource_produced.position = screen_position + Vector2(-40, -90)

func _initialize_building(building_info: BuildingData) -> void:
	print("Initializing building: ", building_info.name)
	
	# NO CONSTRUCTION COMPONENT - Buildings are immediately functional
	# Add production component if building has consumption or production
	if not building_info.consumption_per_turn.is_empty() or not building_info.production_per_turn.is_empty():
		var production_comp = ProductionComponent.new(
			building_info.consumption_per_turn,
			building_info.production_per_turn,
			building_info.production_interval
		)
		add_child(production_comp)
		print("Production component added as child node")

func setup(data: BuildingData) -> void:
	if not is_node_ready():
		await ready
	
	building_data = data
	meshBuilding.mesh = data.model
	_initialize_building(data)

func _on_input_event(_camera: Node, event: InputEvent, _event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	if event.is_action_pressed("select"):
		Events.building_clicked.emit(building_data)
		print("Building clicked: ", building_data.name)

func _on_mouse_entered() -> void:
	highlighter.highlight()

func _on_mouse_exited() -> void:
	highlighter.clear_highlight()

func _on_timer_showing_timeout() -> void:
	if resource_produced:
		resource_produced.visible = false

# Helper method to get production component
func get_production_component() -> ProductionComponent:
	for child in get_children():
		if child is ProductionComponent:
			return child
	return null

# Helper method to get production status
func get_production_status() -> String:
	var production_comp = get_production_component()
	if production_comp:
		return production_comp.get_status()
	return "No production"

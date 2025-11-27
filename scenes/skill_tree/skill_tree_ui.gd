# SkillTreeUI.gd - UI controller for displaying the skill tree
extends Control

signal decision_selected(decision: Decision)

@onready var decision_container: Control = $DecisionContainer
@onready var decision_points_label: Label = $DecisionPointsLabel
@onready var info_panel: Panel = $Panel
@onready var info_title: Label = $Panel/vboxPanel/info_title
@onready var info_description: Label = $Panel/vboxPanel/info_description
@onready var info_cost: Label = $Panel/vboxPanel/info_cost
@onready var confirm_button: Button = $Panel/vboxPanel/confirm_button

var decisions: Array[Decision] = []
var decision_nodes: Dictionary = {} # decision_id -> DecisionNode
var selected_decision: Decision = null

const DecisionNodeScene = preload("res://scenes/skill_tree/decision_node.tscn")

func _ready():
	confirm_button.pressed.connect(_on_confirm_button_pressed)
	info_panel.hide()
	# Ensure decision_container is visible and properly sized
	decision_container.size = size
	decision_container.show()

func setup_decisions(decision_array: Array[Decision]):
	decisions = decision_array
	_create_decision_nodes()
	_draw_connections()
	update_decision_points_display(get_parent().available_decision_points)

func _create_decision_nodes():
	# Clear existing nodes and lines
	for child in decision_container.get_children():
		child.queue_free()
	decision_nodes.clear()
	
	# Create nodes for each decision
	for decision in decisions:
		var decision_node = DecisionNodeScene.instantiate()
		decision_container.add_child(decision_node)
		
		decision_node.setup_decision(decision)
		# Center the node by offsetting position by half its size
		decision_node.position = decision.tree_position - decision_node.size / 2
		decision_node.decision_clicked.connect(_on_decision_node_clicked)
		
		decision_nodes[decision.id] = decision_node
		print("Created node for: ", decision.title, " at ", decision.tree_position)

func _draw_connections():
	# Clear existing lines
	for child in decision_container.get_children():
		if child is Line2D:
			child.queue_free()
	
	# Draw lines between connected decisions
	for decision in decisions:
		var current_node = decision_nodes.get(decision.id)
		if not current_node:
			print("No node found for decision: ", decision.id)
			continue
		
		for next_id in decision.next_decisions:
			var next_node = decision_nodes.get(next_id)
			if next_node:
				_create_connection_line(current_node, next_node)
			else:
				print("No next node found for ID: ", next_id)

func _center_node_on_screen(node: Control):
	if not node:
		return

	# Calculate where the node currently appears on screen
	var node_center_on_screen = decision_container.position + node.position + node.size / 2
	var screen_center = decision_container.size / 2  # Assuming this is your viewport center
	
	# Calculate how much to offset the container
	var container_offset = decision_container.position + (screen_center - node_center_on_screen)

	# Optional smooth movement using Tween
	var tween := create_tween()
	tween.tween_property(decision_container, "position", container_offset, 0.3).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
func _create_connection_line(from_node: Control, to_node: Control):
	var line = Line2D.new()
	decision_container.add_child(line)
	
	# Calculate connection points (center of each node)
	var from_pos = from_node.position + from_node.size / 2
	var to_pos = to_node.position + to_node.size / 2

	# Bezier curve approximation using multiple points
	var points := []
	var mid_point = (from_pos + to_pos) / 2
	var control_point = mid_point + Vector2(0, -50)  # Curve upwards

	# Generate points along the curve
	var resolution := 16
	for i in range(resolution + 1):
		var t := i / float(resolution)
		var p0 := from_pos.lerp(control_point, t)
		var p1 := control_point.lerp(to_pos, t)
		points.append(p0.lerp(p1, t))

	for point in points:
		line.add_point(point)

	line.width = 3.0
	line.default_color = Color(0.4, 0.4, 0.4, 0.8) # Frostpunk-like gray
	line.antialiased = true
	
	# Move line behind nodes
	decision_container.move_child(line, 0)
	print("Drawing line from ", from_pos, " to ", to_pos)


func _on_decision_node_clicked(decision: Decision):
	selected_decision = decision
	_show_info_panel(decision)
	decision_selected.emit(decision)
	_center_node_on_screen(decision_nodes[decision.id])

func _show_info_panel(decision: Decision):
	if not decision:
		info_panel.hide()
		return
	
	info_panel.show()
	info_title.text = decision.title
	info_description.text = decision.description
	info_cost.text = "Cost: " + str(decision.cost) + " Decision Points"
	
	var can_complete = decision.is_unlocked and not decision.is_completed and not decision.is_locked_out
	var has_points = get_parent().available_decision_points >= decision.cost
	confirm_button.disabled = not (can_complete and has_points)
	
	if decision.is_completed:
		confirm_button.text = "COMPLETED"
	elif decision.is_locked_out:
		confirm_button.text = "LOCKED OUT"
	elif not decision.is_unlocked:
		confirm_button.text = "LOCKED"
	else:
		confirm_button.text = "COMPLETE"

func _on_confirm_button_pressed():
	if selected_decision and get_parent().has_method("complete_decision"):
		get_parent().complete_decision(selected_decision.id)
		info_panel.hide()

func update_decision_points_display(points: int):
	decision_points_label.text = "Decision Points: " + str(points)

func refresh_all_nodes():
	for node in decision_nodes.values():
		node.update_visual_state()

func focus_on_decision(decision_id: String):
	var decision = null
	for d in decisions:
		if d.id == decision_id:
			decision = d
			break
	if decision:
		_on_decision_node_clicked(decision)

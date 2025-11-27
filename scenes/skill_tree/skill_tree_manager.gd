# SkillManager.gd - Main manager for the skill tree system
extends Control

signal decision_completed(decision: Decision)
signal decision_unlocked(decision: Decision)

@onready var skill_tree_ui: Control = $SkillTreeUI
@export var decisions: Array[Decision] = []
var available_decision_points: int = 0
var completed_decision_ids: Array[String] = []

func _ready():
	_setup_skills()
	_initialize_skill_tree()
	available_decision_points = 20

func _setup_skills():
	
	var container_center = skill_tree_ui.decision_container.size / 2  # Dynamic center based on actual UI
	for decision in decisions:
		if decision.layer == 0:
			decision.tree_position = container_center
		else:
			decision.tree_position = container_center + decision.tree_position


func _initialize_skill_tree():
	if skill_tree_ui and skill_tree_ui.has_method("setup_decisions"):
		skill_tree_ui.setup_decisions(decisions)
		skill_tree_ui.decision_selected.connect(_on_decision_selected)
		skill_tree_ui.update_decision_points_display(available_decision_points)

func get_decision_by_id(decision_id: String) -> Decision:
	for decision in decisions:
		if decision.id == decision_id:
			return decision
	return null

func complete_decision(decision_id: String) -> bool:
	var decision = get_decision_by_id(decision_id)
	if not decision:
		print("Decision not found: ", decision_id)
		return false
	
	if not decision.can_be_unlocked(completed_decision_ids):
		print("Decision cannot be completed: ", decision_id)
		return false
	
	if available_decision_points < decision.cost:
		print("Not enough decision points for: ", decision_id)
		return false
	
	decision.is_completed = true
	available_decision_points -= decision.cost
	completed_decision_ids.append(decision_id)
	
	_lock_out_exclusive_decisions(decision)
	_unlock_next_decisions(decision)
	
	skill_tree_ui.update_decision_points_display(available_decision_points)
	skill_tree_ui.refresh_all_nodes()
	
	decision_completed.emit(decision)
	print("Decision completed: ", decision.title)
	return true

func add_decision_points(amount: int):
	available_decision_points += amount
	skill_tree_ui.update_decision_points_display(available_decision_points)
	_update_decision_availability()

func _lock_out_exclusive_decisions(completed_decision: Decision):
	for exclusive_id in completed_decision.mutually_exclusive_with:
		var exclusive_decision = get_decision_by_id(exclusive_id)
		if exclusive_decision and not exclusive_decision.is_completed:
			exclusive_decision.is_locked_out = true

func _unlock_next_decisions(completed_decision: Decision):
	for next_id in completed_decision.next_decisions:
		var next_decision = get_decision_by_id(next_id)
		if next_decision and next_decision.can_be_unlocked(completed_decision_ids):
			next_decision.is_unlocked = true
			decision_unlocked.emit(next_decision)

func _update_decision_availability():
	for decision in decisions:
		if not decision.is_completed and not decision.is_locked_out:
			var was_unlocked = decision.is_unlocked
			var can_unlock = decision.can_be_unlocked(completed_decision_ids)
			if not was_unlocked and can_unlock:
				decision.is_unlocked = true
				decision_unlocked.emit(decision)
	skill_tree_ui.refresh_all_nodes()

func _on_decision_selected(decision: Decision):
	print("Decision selected: ", decision.title)


func show_skill_tree() -> void:
	visible = true
	print("Skill tree shown")

func hide_skill_tree() -> void:
	visible = false
	#menu_closed.emit()
	#print("Building menu hidden")


func _on_button_pressed() -> void:
	hide_skill_tree()

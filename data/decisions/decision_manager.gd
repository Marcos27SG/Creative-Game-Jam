# res://managers/decision_manager.gd
extends Node
class_name DecisionManager

signal decision_triggered(decision: Decision)
signal decision_completed(decision: Decision, option_index: int)

@export var decision_pool: Array[Decision] = []
var pending_decisions: Array[Decision] = []
var completed_decision_ids: Array[String] = []

func _ready():
	# Load all decisions from a directory (optional)
	# load_decisions_from_directory("res://resources/decisions/pool/")
	pass

func load_decisions_from_directory(path: String) -> void:
	var dir = DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if file_name.ends_with(".tres"):
				var decision = load(path + file_name) as Decision
				if decision and decision not in decision_pool:
					decision_pool.append(decision)
			file_name = dir.get_next()
		dir.list_dir_end()

func check_triggers(current_day: int, current_stage: int) -> void:
	for decision in decision_pool:
		# Skip already completed decisions
		if decision.id in completed_decision_ids:
			continue
		
		# Check if decision should trigger
		if decision.trigger_day == current_day and decision.trigger_stage == current_stage:
			trigger_decision(decision)

func trigger_decision(decision: Decision) -> void:
	pending_decisions.append(decision)
	decision_triggered.emit(decision)

func make_decision(decision: Decision, option_index: int, game_state) -> void:
	var option = decision.get_option(option_index)
	if option:
		# Apply effects
		option.apply_effects(game_state)
		
		# Mark as completed
		completed_decision_ids.append(decision.id)
		pending_decisions.erase(decision)
		
		decision_completed.emit(decision, option_index)

func has_pending_decisions() -> bool:
	return pending_decisions.size() > 0

func get_next_pending_decision() -> Decision:
	if pending_decisions.size() > 0:
		return pending_decisions[0]
	return null

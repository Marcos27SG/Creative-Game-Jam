# Decision.gd - Resource that stores decision information
class_name Decision
extends Resource

@export var id: String
@export var title: String
@export_multiline var description: String
@export var icon: Texture2D
@export var cost: int = 1
@export var previous_decisions: Array[String] = []
@export var next_decisions: Array[String] = []
@export var mutually_exclusive_with: Array[String] = []
@export var layer: int = 0
@export var is_unlocked: bool = false
@export var is_completed: bool = false
@export var is_locked_out: bool = false
@export var tree_position: Vector2

func _init(decision_id: String = "", decision_title: String = ""):
	id = decision_id
	title = decision_title

func can_be_unlocked(completed_decisions: Array[String]) -> bool:
	if is_completed or is_locked_out:
		return false
	for prev_id in previous_decisions:
		if prev_id not in completed_decisions:
			return false
	return true

func get_preview_node_id() -> String:
	if previous_decisions.is_empty():
		return ""
	return previous_decisions[0]

func has_next_nodes() -> bool:
	return not next_decisions.is_empty()

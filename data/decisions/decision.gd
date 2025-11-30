# res://resources/decisions/decision.gd
extends Resource
class_name Decision

@export var id: String
@export var title: String
@export_multiline var description: String
@export var options: Array[DecisionChoice] = []

func _execute_choice (_choice_index: int ) -> void:
	pass

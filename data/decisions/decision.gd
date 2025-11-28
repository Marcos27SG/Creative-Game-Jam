# res://resources/decisions/decision.gd
extends Resource
class_name Decision

@export var id: String
@export var title: String
@export_multiline var description: String
@export var trigger_day: int
@export var trigger_stage: int
@export var options: Array[DecisionOption] = []

func get_option(index: int) -> DecisionOption:
	if index >= 0 and index < options.size():
		return options[index]
	return null

# res://resources/decisions/decision_option.gd
extends Resource
class_name DecisionOption

@export var text: String
@export var effects: Array[DecisionEffect] = []

func apply_effects(game_state) -> void:
	for effect in effects:
		effect.apply(game_state)

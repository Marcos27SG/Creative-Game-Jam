# res://resources/decisions/decision_option.gd
extends Resource
class_name DecisionChoice

@export_multiline var description: String
@export var choice_index: int
#@export var effects: Array[DecisionEffect] = []
#
#func apply_effects(game_state) -> void:
	#for effect in effects:
		#effect.apply(game_state)

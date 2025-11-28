# res://resources/decisions/decision_effect.gd
extends Resource
class_name DecisionEffect

enum EffectType {
	MODIFY_RESOURCE,
	TRIGGER_EVENT,
	UNLOCK_FEATURE
}

@export var effect_type: EffectType = EffectType.MODIFY_RESOURCE
@export var resource_name_test: String  # e.g., "energy", "morale"
@export var value: float  # positive or negative

func apply(game_state) -> void:
	match effect_type:
		EffectType.MODIFY_RESOURCE:
			if game_state.has_method("modify_resource"):
				game_state.modify_resource(resource_name, value)
		EffectType.TRIGGER_EVENT:
			# Implement custom event logic
			pass
		EffectType.UNLOCK_FEATURE:
			# Implement unlock logic
			pass

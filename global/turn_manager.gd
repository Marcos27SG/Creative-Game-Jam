extends Node

signal turn_started(turn_number: int)
signal turn_ended(turn_number: int)
signal day_started(day_number: int)
signal day_ended(day_number: int)
signal state_changed()

var current_turn: int = 0:
	set(value):
		if current_turn != value:
			current_turn = value
			state_changed.emit()

var current_day: int = 0:
	set(value):
		if current_day != value:
			current_day = value
			state_changed.emit()

var time_of_day_index: int = 0:
	set(value):
		if time_of_day_index != value:
			time_of_day_index = value
			state_changed.emit()

const TURNS_PER_DAY: int = 3
const MAX_DAYS: int = 9
enum TimeOfDay { DAWN, AFTERNOON, EVENING }

var current_day_and_turn: String:
	get:
		return "Day: %s Turn: %s Time: %s" % [current_day, current_turn, TimeOfDay.keys()[time_of_day_index]]

func advance_turn() -> void:
	turn_started.emit(current_turn + 1)
	
	# Store old values for comparison
	var old_turn = current_turn
	var old_day = current_day
	
	current_turn += 1
	
	# Update time of day based on the new turn
	time_of_day_index = ((current_turn - 1) % TURNS_PER_DAY)
	
	# Process all turn-based systems
	_process_turn()
	
	turn_ended.emit(current_turn)
	
	# Emit event based on time of day
	var time_of_day = get_time_of_day()
	match time_of_day:
		TimeOfDay.DAWN:
			Events.strategy_choice_triggered.emit(current_day)
		TimeOfDay.AFTERNOON:
			#print("Make the Critical Decision")
			Events.crisis_choice_triggered.emit(current_day)
		TimeOfDay.EVENING:
			#print("Make the Critical Decision")
			#Events.criticalDecisionEvent.emit()
			if current_day < MAX_DAYS:
				Events.choiceBuildingEvent.emit()
			if current_day == MAX_DAYS:
				Events.game_won.emit()

	
	# Check if day ended (after processing the turn)
	if old_turn % TURNS_PER_DAY == 0:
		day_ended.emit(old_day)
		current_day += 1
		day_started.emit(current_day)

func _process_turn() -> void:
	# This will be handled by systems that connect to the signals
	pass

func get_time_of_day() -> TimeOfDay:
	var turn_in_day = ((current_turn - 1) % TURNS_PER_DAY)
	match turn_in_day:
		0: return TimeOfDay.DAWN
		1: return TimeOfDay.AFTERNOON
		2: return TimeOfDay.EVENING
		_: return TimeOfDay.DAWN

func get_turns_remaining_in_day() -> int:
	return TURNS_PER_DAY - ((current_turn - 1) % TURNS_PER_DAY)

func get_time_of_day_name() -> String:
	return TimeOfDay.keys()[get_time_of_day()]

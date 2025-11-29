extends Node

signal turn_started (turn_number: int)
signal turn_ended (turn_number: int)
signal day_started (day_number: int)
signal day_ended (day_number: int)

var current_turn: int = 0
var current_day: int = 1
const TURNS_PER_DAY: int = 3
const MAX_DAYS: int = 10
enum TimeOfDay { DAWN, AFTERNOON, EVENING }

#func _ready() -> void:
	## Start the first turn automatically
	#call_deferred("advance_turn")

func advance_turn() -> void:
	turn_started.emit(current_turn + 1)
	current_turn += 1
	
	# Process all turn-based systems
	_process_turn()
	
	turn_ended.emit(current_turn)
	
	# Emit event based on time of day
	var time_of_day = get_time_of_day()
	match time_of_day:
		TimeOfDay.DAWN:
			print("Make the Strategy Decission")
		TimeOfDay.AFTERNOON:
			print("Make the Critical Decission")
			#Events.progressDecisionEvent.emit()
		TimeOfDay.EVENING:
			Events.choiceBuildingEvent.emit()
			print("Make the Critical Decission")
			#Events.criticalDecisionEvent.emit()
			if current_day == MAX_DAYS:
				#game_won.emit()
				print("🎉 Congratulations! You've completed all 9 days!")
	# Check if day ended
	if current_turn % TURNS_PER_DAY == 0:
		day_ended.emit(current_day)
		current_day += 1
		day_started.emit(current_day)
	
	print("Day: ", current_day, " Turn: ", current_turn, " Time: ", TimeOfDay.keys()[time_of_day])

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
	return TURNS_PER_DAY - (current_turn % TURNS_PER_DAY)

func get_time_of_day_name() -> String:
	return TimeOfDay.keys()[get_time_of_day()]

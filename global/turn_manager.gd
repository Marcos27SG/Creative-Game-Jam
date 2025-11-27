extends Node

signal turn_started (turn_number: int)
signal turn_ended (turn_number: int)
signal day_started (day_number: int)
signal day_ended (day_number: int)

var current_turn: int = 0
var current_day: int = 1
var turns_per_day: int = 5

func advance_turn() -> void:
	turn_started.emit(current_turn + 1)
	current_turn += 1
	
	# Process all turn-based systems
	_process_turn()
	
	turn_ended.emit(current_turn)
	
	# Check if day ended
	if current_turn % turns_per_day == 0:
		day_ended.emit(current_day)
		current_day += 1
		day_started.emit(current_day)
		
	print(current_day)

func _process_turn() -> void:
	# This will be handled by systems that connect to the signals
	pass

func get_turns_remaining_in_day() -> int:
	return turns_per_day - (current_turn % turns_per_day)

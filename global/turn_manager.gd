extends Node

signal turn_started (turn_number: int)
signal turn_ended (turn_number: int)
signal day_started (day_number: int)
signal day_ended (day_number: int)
signal stage_changed(day: int, stage: int)
signal day_changed(day: int)
var current_turn: int = 0
var current_day: int = 1
var turns_per_day: int = VillageStats.turns_per_day

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
#@onready var decision_manager: DecisionManager = $DecisionManager
#@onready var game_state: GameState = $GameState

func _ready():
	pass
	# Connect to decision manager
	#if decision_manager:
		#decision_manager.decision_triggered.connect(_on_decision_triggered)
#
#func advance_stage() -> void:
	#current_stage += 1
	#
	#if current_stage > stages_per_day:
		#current_stage = 1
		#current_day += 1
		#day_changed.emit(current_day)
	#
	#stage_changed.emit(current_day, current_stage)
	#
	## Check for decisions to trigger
	#if decision_manager:
		#decision_manager.check_triggers(current_day, current_stage)
#
#func _on_decision_triggered(decision: Decision) -> void:
	## Pause game or show decision UI
	#print("Decision triggered: ", decision.title)
	## You would typically pause the game here and show the UI
	## get_tree().paused = true

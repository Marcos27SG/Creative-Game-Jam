extends Control
@export var decision_pool: Array[Decision]

@onready var decision_title: Label = $VBoxContainer/decision_title
@onready var decision_description: RichTextLabel = $VBoxContainer/decision_description
@onready var description: Label = $"VBoxContainer/HBoxContainer/First Choice/Description"
@onready var sc_description: Label = $VBoxContainer/HBoxContainer/SecondChoice/SC_description
@onready var first_choice_action: Button = $"VBoxContainer/HBoxContainer/First Choice/FirstChoiceAction"
@onready var second_choice_action: Button = $VBoxContainer/HBoxContainer/SecondChoice/SecondChoiceAction

var currrentDecision 

func _ready() -> void:
	#pass
	Events.strategy_choice_triggered.connect(show_new_strategy)
	
func show_new_strategy(decision_day) -> void:
	self.show()
	show_strategy_decision(decision_day)
func show_strategy_decision(decision_day) -> void:
	#self.show()
	print(decision_day)
	var decision = decision_pool[decision_day] 
	currrentDecision = decision
	decision_title.text = decision.title
	decision_description.text = decision.description
	description.text = decision.options[0].description
	sc_description.text = decision.options[1].description
	


func _on_first_choice_action_pressed() -> void:
	currrentDecision._execute_choice(0)
	self.hide()


func _on_second_choice_action_pressed() -> void:
	currrentDecision._execute_choice(1)
	self.hide()

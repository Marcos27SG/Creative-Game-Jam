# DecisionNode.gd - Individual decision node UI component
extends Control

signal decision_clicked(decision: Decision)

@onready var background: ColorRect = $background
@onready var button: Button = $Button
@onready var icon: TextureRect = $Button/Icon
@onready var title_label: Label = $TitleLabel

var decision: Decision

# Visual states
var normal_color = Color(0.3, 0.3, 0.3, 1.0)      # Dark gray - locked
var unlocked_color = Color(0.2, 0.6, 1.0, 1.0)    # Blue - available
var completed_color = Color(0.2, 0.8, 0.2, 1.0)   # Green - completed
var locked_out_color = Color(0.8, 0.2, 0.2, 1.0)  # Red - locked out

func _ready():
	button.pressed.connect(_on_button_pressed)
	button.mouse_entered.connect(_on_mouse_entered)
	button.mouse_exited.connect(_on_mouse_exited)
	
	# Set initial size
	#custom_minimum_size = Vector2(80, 80)
	#size = custom_minimum_size
	update_visual_state()  # Ensure initial state is set

func setup_decision(new_decision: Decision):
	decision = new_decision
	if not decision:
		return
	
	title_label.text = decision.title

	
	update_visual_state()
	print("Node created for decision: ", decision.title, " at position: ", position)

func update_visual_state():
	if not decision:
		return
	
	var target_color: Color
	var is_clickable = false
	
	if decision.is_completed:
		target_color = completed_color
		is_clickable = true
	elif decision.is_locked_out:
		target_color = locked_out_color
		is_clickable = false
	elif decision.is_unlocked:
		target_color = unlocked_color
		is_clickable = true
	else:
		target_color = normal_color
		is_clickable = false
	
	background.color = target_color
	button.disabled = not is_clickable
	
	if is_clickable:
		button.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	else:
		button.mouse_default_cursor_shape = Control.CURSOR_ARROW

func _on_button_pressed():
	if decision:
		decision_clicked.emit(decision)

func _on_mouse_entered():
	if decision and not button.disabled:
		var tween = create_tween()
		tween.tween_property(self, "scale", Vector2.ONE * 1.1, 0.1)

func _on_mouse_exited():
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2.ONE, 0.1)

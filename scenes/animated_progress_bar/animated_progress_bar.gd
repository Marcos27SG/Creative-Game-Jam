class_name MoraleStatBar
extends ProgressBar
@export var title: String = "stat"
@export var color: Color = Color.WHITE
@export var animate: bool = true

@onready var fill_bar: ProgressBar = $ProgressBar
@onready var label: Label = $Label
@onready var timer: Timer = $ProgressBar/Timer
# Health and block variables
var value_current: int = 0 : set = _set_value
var tween_fill: Tween
var tween_front: Tween

@export var init_value := 100

func _ready() -> void:
	if not timer.is_connected("timeout", _on_timer_timeout):
		timer.connect("timeout", _on_timer_timeout)
	init_stat(init_value)

func init_stat(max_val: int) -> void:
	max_value = max_val
	fill_bar.max_value = max_val
	value = max_val
	fill_bar.value = max_val
	value_current = max_val
	label.text = title

	# Duplicate style to avoid shared reference
	var styleboxbar = get_theme_stylebox("fill").duplicate()
	add_theme_stylebox_override("fill", styleboxbar)
	styleboxbar.set("bg_color", color)


func _set_value(new_val: int) -> void:
	var prev_val = value_current
	value_current = clamp(new_val, 0, max_value)

	if animate:
		if tween_front and tween_front.is_running():
			tween_front.kill()
		tween_front = create_tween()
		tween_front.tween_property(self, "value", value_current, 0.3).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)

		if value_current < prev_val:
			timer.start()
		else:
			if tween_fill and tween_fill.is_running():
				tween_fill.kill()
			tween_fill = create_tween()
			tween_fill.tween_property(fill_bar, "value", value_current, 0.3).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	else:
		value = value_current
		fill_bar.value = value_current

func _on_timer_timeout() -> void:
	if tween_fill and tween_fill.is_running():
		tween_fill.kill()
	tween_fill = create_tween()
	tween_fill.tween_property(fill_bar, "value", value_current, 0.5).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)

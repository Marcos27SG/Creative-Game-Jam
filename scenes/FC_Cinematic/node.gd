extends Node

@export var FirstText: RichTextLabel
@export var SecondText: RichTextLabel

@export var text_pairs: Array[Dictionary] = [
	{
		"first": "Year 2132. Earth's resources...",
		"second": "exhausted."
	},
	{
		"first": "27 colony missions failed. Hope...",
		"second": "fading."
	},
	{
		"first": "The void claimed them all.",
		"second": "But surrender was never an option."
	},
	{
		"first": "Four alliances. One planet. K1LA-32:",
		"second": "32% survival probability"
	},
	{
		"first": "Four launches. One mission. Survive 10 cycles...",
		"second": "or humanity dies."
	},
	{
		"first": "Americas launches first. Your colony.",
		"second": "Your burden."
	},
	{
		"first": "Day 1 begins now.",
		"second": "Make it count."
	}
]

var _current_index := -1


# ---------------------------------
# PUBLIC: Call this with the index
# ---------------------------------
func play_text_pair(index: int) -> void:
	if index < 0 or index >= text_pairs.size():
		push_error("Invalid text pair index: %s" % index)
		return

	_current_index = index
	reset_texts()

	var pair = text_pairs[index]
	_show_first_text(pair["first"], pair["second"])


# ---------------------------------
# FIRST TEXT (TYPEWRITER)
# ---------------------------------
func _show_first_text(first: String, second: String):
	FirstText.show()
	FirstText.text = first
	FirstText.visible_ratio = 0
	FirstText.modulate = Color.WHITE

	var tween = create_tween()
	tween.tween_property(FirstText, "visible_ratio", 1.0, 2.0)
	tween.tween_callback(func():
		_on_first_text_done(second))


func _on_first_text_done(second_text: String):
	var delay = create_tween()
	delay.tween_interval(0.5)
	delay.tween_callback(func():
		_show_second_text(second_text))


# ---------------------------------
# SECOND TEXT (FADE-IN)
# ---------------------------------
func _show_second_text(second: String):
	SecondText.show()
	SecondText.text = second
	SecondText.modulate = Color.TRANSPARENT

	var tween = create_tween()
	tween.tween_property(SecondText, "modulate", Color.WHITE, 1.0).from(Color.TRANSPARENT)
	#tween.tween_callback(reset_texts)

# ---------------------------------
# RESET
# ---------------------------------
func reset_texts():
	FirstText.hide()
	FirstText.visible_ratio = 0
	FirstText.modulate = Color.TRANSPARENT

	SecondText.hide()
	SecondText.modulate = Color.TRANSPARENT

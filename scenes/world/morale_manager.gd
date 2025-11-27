class_name MoraleManager
extends Control

signal hope_changed(new_value: int)
signal discontent_changed(new_value: int)

@export var max_hope := 100
@export var max_discontent := 100


@onready var discontent_bar: MoraleStatBar = $Discontent
@onready var hope_bar: MoraleStatBar = $Hope

var hope := 100 : set = set_hope
var discontent := 0 : set = set_discontent

func _ready():
	hope_bar.title = "Hope"
	hope_bar.color = Color(0.3, 0.8, 1.0)
	hope_bar.init_stat(max_hope)
	hope_bar.value_current = hope_bar.init_value

	discontent_bar.title = "Discontent"
	discontent_bar.color = Color(1.0, 0.3, 0.3)
	discontent_bar.init_stat(max_discontent)
	discontent_bar.value_current = discontent_bar.init_value
	
	
	discontent_bar.animate = true
	hope_bar.animate = true
	
	#WorldEvents.connect("hope_changed", Callable(self, "_on_hope_changed"))
	#WorldEvents.connect("discontent_changed", Callable(self, "_on_discontent_changed"))
	#Emit Signals
	#WorldEvents.emit_signal("hope_changed", -10)
	#WorldEvents.emit_signal("discontent_changed", 15)

func _on_hope_changed(delta: int):
	change_hope(delta)

func _on_discontent_changed(delta: int):
	change_discontent(delta)

func set_hope(value: int) -> void:
	hope = clamp(value, 0, max_hope)
	hope_bar._set_health(hope)
	emit_signal("hope_changed", hope)

	if hope <= 20:
		show_warning("Hope is critically low!")

func set_discontent(value: int) -> void:
	discontent = clamp(value, 0, max_discontent)
	discontent_bar._set_health(discontent)
	emit_signal("discontent_changed", discontent)

	if discontent >= 80:
		show_warning("Discontent is dangerously high!")

func change_hope(delta: int) -> void:
	set_hope(hope + delta)

func change_discontent(delta: int) -> void:
	set_discontent(discontent + delta)

func show_warning(text: String):
	print("[Morale Warning] " + text)
	# Add your in-game popup/notification system here.

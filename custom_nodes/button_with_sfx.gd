class_name ButtonWithSFX extends Button
const SFX_CLICK_BUTTON = preload("uid://b7qk48uwcjm2c")
const SFX_HOVER_BUTTON = preload("uid://dsvwuaipfkctn")

@onready var mouse_entered_vfx: AudioStream = SFX_CLICK_BUTTON
@onready var mouse_pressed_vfx: AudioStream = SFX_HOVER_BUTTON


@onready var hover_stylebox: StyleBox = get_theme_stylebox("hover")

func _ready() -> void :
	pressed.connect(_on_pressed)
	mouse_entered.connect(_on_mouse_entered)
	focus_entered.connect(_on_focus_entered)
	focus_exited.connect(_on_focus_exited)
	is_hovered()

func _on_mouse_entered() -> void :
	if !disabled:
		SFXPlayer.play(mouse_entered_vfx)

func _on_pressed() -> void :
	if !disabled:
		SFXPlayer.play(mouse_pressed_vfx)

func _on_focus_entered() -> void :


	add_theme_stylebox_override("normal", hover_stylebox)
	add_theme_stylebox_override("focus", StyleBoxEmpty.new())
	queue_redraw()

func _on_focus_exited() -> void :

	remove_theme_stylebox_override("normal")
	remove_theme_stylebox_override("focus")
	queue_redraw()

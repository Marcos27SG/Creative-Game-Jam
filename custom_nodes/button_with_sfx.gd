class_name ButtonWithSFX extends Button

@export var mouse_entered_vfx: SFXData.Type = SFXData.Type.UI_BUTTON_ENTERED
@export var mouse_pressed_vfx: SFXData.Type = SFXData.Type.UI_BUTTON_CLICKED

@onready var hover_stylebox: StyleBox = get_theme_stylebox("hover")

func _ready() -> void :
	pressed.connect(_on_pressed)
	mouse_entered.connect(_on_mouse_entered)
	focus_entered.connect(_on_focus_entered)
	focus_exited.connect(_on_focus_exited)
	is_hovered()

func _on_mouse_entered() -> void :
	if !disabled:
		SFXManager.create_audio(mouse_entered_vfx)
	print("sound mouse entered")

func _on_pressed() -> void :
	if !disabled:
		SFXManager.create_audio(mouse_pressed_vfx)
	print("sound  preseed")

func _on_focus_entered() -> void :


	add_theme_stylebox_override("normal", hover_stylebox)
	add_theme_stylebox_override("focus", StyleBoxEmpty.new())
	queue_redraw()
	print("sound focus")

func _on_focus_exited() -> void :

	remove_theme_stylebox_override("normal")
	remove_theme_stylebox_override("focus")
	queue_redraw()

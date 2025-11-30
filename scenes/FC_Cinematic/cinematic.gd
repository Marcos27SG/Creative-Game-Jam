extends Control


#@onready var rich_text_label: RichTextLabel = $FirstPanel/RichTextLabel
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	##pass
	animation_player.play("cinematic")

#var firstPanelText = "Day 1 begins now. Make it count."


#func _write_text(text) -> void:
	#rich_text_label.text = text
	#

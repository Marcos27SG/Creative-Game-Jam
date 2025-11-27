extends Node3D
const END = preload("res://marketing/end.mp3")
const TYPEWRITERCUT = preload("res://marketing/typewritercut.mp3")

@onready var texture_rect: TextureRect = $TextureRect
@onready var buildings_stone_rebellion_core_engine: MeshInstance3D = $BuildingsStoneRebellionCoreEngine

@onready var mat := texture_rect.material as ShaderMaterial
@onready var buildings_stone_rebellion_house: MeshInstance3D = $BuildingsStoneRebellionHouse

var active := false
var progress := 0.0
var speed := 0.7


func _ready():
	pass
	#var tween = create_tween()
	#tween.tween_property(buildings_stone_rebellion_core_engine, "rotation:y", rotation.y + deg_to_rad(3000), 60.0)
	
func _process(delta: float) -> void:
	
	if active:
		progress = clamp(progress + delta * speed, 0.0, 1.0)
		mat.set_shader_parameter("progress", progress)
		#mat2.set_shader_"res://typewriter.ogg"parameter("progress", progress)
		
		if progress >= 1.0:
			MusicPlayer.stop()
			#audio_stream_player_2d.stop()
			active = false # Auto-reset when don
			#audio_stream_player_2d.stop()
			
		
			
@onready var animation_player: AnimationPlayer = $AnimationPlayer
func _input(event):
	if event.is_action_pressed("test1"): # Press Space@onready var animation_player: AnimationPlayer = $AnimationPlayer
		animation_player.play("new_animation")
		#texture_rect.visible = true
		#progress = 0.0w wal
		#active = true
		#mat.set_shader_parameter("progress", 0.0)
		MusicPlayer.play(TYPEWRITERCUT)
		#mat2.set_shader_parameter("progress", 0.0)
	
	if event.is_action_pressed("test2"):
		MusicPlayer.play(END)
		start_animation()
		
func start_animation() :
	var tween = create_tween()
	tween.tween_property(buildings_stone_rebellion_house, "rotation:y", rotation.y + deg_to_rad(800), 20)
	

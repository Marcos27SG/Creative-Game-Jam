class_name Arena
extends Node3D

@export var arena_music_stream: AudioStream

@onready var sell_portal: SellPortal = $SellPortal
@onready var unit_mover: UnitMover = $UnitMover
@onready var unit_spawner: UnitSpawner = $UnitSpawner
@onready var unit_combiner: UnitCombiner = $UnitCombiner
@onready var shop: Shop = %Shop
@onready var play_area: PlayArea = $PlayArea
#@onready var battle_unit_grid: UnitGrid = $PlayArea/BattleUnitGrid

func _ready() -> void:
	unit_spawner.unit_spawned.connect(unit_mover.setup_unit)
	#unit_spawner.unit_spawned.connect(sell_portal.setup_unit)
	unit_spawner.unit_spawned.connect(unit_combiner.queue_unit_combination_update.unbind(1))
	shop.unit_bought.connect(unit_spawner.spawn_unit)
	#MusicPlayer.play(arena_music_stream)
	#UnitNavigation.initialize(battle_unit_grid , play_area)

class_name TileHighlighter
extends Node3D

@export var enabled: bool = true : set = _set_enabled
@export var play_area: PlayArea
@export var highlight_mesh: MeshInstance3D

func _ready() -> void:
	if highlight_mesh:
		highlight_mesh.visible = false
		print("HighlightMesh initialized, visible: ", highlight_mesh.visible)
	else:
		print("ERROR: HighlightMesh not assigned!")

func _process(_delta: float) -> void:
	if not enabled:
		#print("TileHighlighter disabled, skipping process")
		return

	var selected_tile := play_area.get_hovered_tile()
	#print("Hovered tile: ", selected_tile)
	
	if not play_area.is_tile_in_bounds(selected_tile):
		highlight_mesh.visible = false
		#print("Tile out of bounds, hiding HighlightMesh, visible: ", highlight_mesh.visible)
		return

	_update_tile(selected_tile)

func _set_enabled(new_value: bool) -> void:
	enabled = new_value
	if not enabled and highlight_mesh:
		highlight_mesh.visible = false
		#print("TileHighlighter disabled, hiding HighlightMesh, visible: ", highlight_mesh.visible)

func _update_tile(selected_tile: Vector2i) -> void:
	highlight_mesh.visible = true
	var tile_pos = play_area.get_global_from_tile(selected_tile)
	highlight_mesh.global_position = tile_pos + Vector3(0, 0.01, 0.0)
	#print("HighlightMesh updated - Tile: ", selected_tile, " Position: ", highlight_mesh.global_position, " Visible: ", highlight_mesh.visible)

class_name World
extends Node2D

const EGG = preload("uid://cluhfhcmt4vrs")

static var _instance : World

static func get_instance() -> World:
	return _instance
	
var tile_map_layer: TileMapLayer
@onready var tile_map_layer_selection: TileMapLayer = $TileMapLayerSelection
@onready var tile_map_layer_background: TileMapLayer = $TileMapLayerBackground

func _ready() -> void:
	_instance = self
	load_level()
	start_machines()

func load_level() -> void:
	for n in get_children():
		if n is TileMapLayer and n != tile_map_layer_selection and n != tile_map_layer_background:
			n.visible = false
	tile_map_layer = get_node("TileMapLayer" + str(Game.current_level))
	if tile_map_layer != null:
		tile_map_layer.visible = true

func get_cell_global_position(cell: Vector2i) -> Vector2:
	var to_local_cell = tile_map_layer.map_to_local(cell)
	var to_global_cell = tile_map_layer.to_global(to_local_cell)
	return to_global_cell

func get_current_cell(gp: Vector2) -> Vector2i:
	return tile_map_layer.local_to_map(tile_map_layer.to_local(gp))

func get_block_direction_tl(gp: Vector2, tl : TileMapLayer) -> Vector2:
	var cell_coords : Vector2i = get_current_cell(gp)
	var atlas_coords : Vector2i = tl.get_cell_atlas_coords(cell_coords)
	if atlas_coords == Vector2i(0, 1) or atlas_coords == Vector2i(0, 3):
		var alt : int = tl.get_cell_alternative_tile(cell_coords)
		match alt:
			0:
				return Vector2.RIGHT
			1:
				return Vector2.LEFT
			2:
				return Vector2.DOWN
			3:
				return Vector2.UP
	if atlas_coords.y == 6:
		return Vector2.RIGHT
	print("return cero")
	return Vector2.ZERO

func get_block_direction(gp: Vector2) -> Vector2:
	var block_direction = get_block_direction_tl(gp, tile_map_layer)
	return block_direction

func get_cell_type(cell : Vector2i) -> int:
	var tile_data = tile_map_layer.get_cell_tile_data(cell)
	if tile_data == null:
		return -1
	return tile_data.get_custom_data("type")

func get_current_cell_type(gp : Vector2) -> int:
	var cell_coords : Vector2i = get_current_cell(gp)
	return get_cell_type(cell_coords)

func start_machines() -> void:
	for c : Vector2i in tile_map_layer.get_used_cells():
		if get_cell_type(c) == Game.CellType.SPAWN:
			var p : Node2D = EGG.instantiate()
			p.global_position = tile_map_layer.to_global(tile_map_layer.map_to_local(c))
			add_child(p)
		

func is_on_map(cell : Vector2i) -> bool:
	return tile_map_layer_background.get_cell_source_id(cell) > -1
	
func is_conveyor(cell : Vector2i) -> bool:
	return get_cell_type(cell) == Game.CellType.CONVEYOR

func is_machine(cell : Vector2i) -> bool:
	return get_cell_type(cell) == Game.CellType.SPAWN

func is_nest(cell : Vector2i) -> bool:
	return get_cell_type(cell) == Game.CellType.NEST

func get_cell_color(cell : Vector2i) -> Color:
	var atlas_coords = tile_map_layer.get_cell_atlas_coords(cell)
	match atlas_coords.x:
		1:
			return Color.RED
		2:
			return Color.BLUE
		3:
			return Color.GREEN
		4:
			return Color.YELLOW
		_:
			return Color.WHITE

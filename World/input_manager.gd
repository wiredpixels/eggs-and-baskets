extends Node2D

@export var world : World

const NULL_CELL = Vector2i(-999, -999)
const SELECTION_CELL = Vector2i(0, 2)
const ARROW_CELL = Vector2i(1, 2)
var last_cell := NULL_CELL

func _ready() -> void:
	Game.wistle.connect(_on_whistle)
	get_tree().paused = true
	Engine.time_scale = 0.0

func _unhandled_input(event: InputEvent) -> void:
	if !get_tree().paused:
		clear_last_cell()
		world.tile_map_layer_selection.clear()
		return

	if event is InputEventMouseMotion:
		var cell := _get_mouse_cell()
		
		if cell == last_cell:
			return
		clear_tile_map_layer_selection()
		if world.is_on_map(cell):
			world.tile_map_layer_selection.set_cell(cell, 0, ARROW_CELL)
	
	elif event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			var cell := _get_mouse_cell()
			select_cell(cell)
	
	elif event is InputEventScreenTouch:
		if event.pressed:
			var cell := _get_cell_from_screen(event.position)
			select_cell(cell)


func _on_whistle() -> void:
	if get_tree().paused:
		get_tree().paused = false
		Engine.time_scale = 1.0
	else:
		get_tree().paused = true
		Engine.time_scale = 0.0
	Audio.play_sound("whistle")


func select_cell(cell : Vector2i) -> void:
	if last_cell == cell:
		last_cell = NULL_CELL
		world.tile_map_layer_selection.set_cell(cell)
		return
		
	if last_cell == NULL_CELL:
		if world.is_conveyor(cell):
			world.tile_map_layer_selection.set_cell(cell, 0, SELECTION_CELL)
			last_cell = cell
	else:
		if is_valid_target(cell):
			swap_tiles(cell)

func is_valid_target(cell : Vector2i) -> bool:
	if world.is_conveyor(cell):
		return false
	if !world.is_on_map(cell):
		return false
	if world.is_machine(cell):
		return false
	if world.is_nest(cell):
		return false
	return true

func swap_tiles(cell : Vector2i) -> void:
	var atlas_coords = world.tile_map_layer.get_cell_atlas_coords(last_cell)
	var alt = world.tile_map_layer.get_cell_alternative_tile(last_cell)
	world.tile_map_layer.set_cell(last_cell)
	world.tile_map_layer.set_cell(cell, 0, atlas_coords, alt)
	clear_last_cell()
	world.tile_map_layer_selection.clear()

func clear_last_cell() -> void:
	last_cell = NULL_CELL

func _get_mouse_cell() -> Vector2i:
	var mouse_pos := get_global_mouse_position()
	return world.tile_map_layer_selection.local_to_map(
		world.tile_map_layer_selection.to_local(mouse_pos)
	)


func _get_cell_from_screen(screen_pos: Vector2) -> Vector2i:
	var world_pos : Vector2 = get_viewport().get_camera_2d().screen_to_world(screen_pos)
	return world.tile_map_layer_selection.local_to_map(
		world.tile_map_layer_selection.to_local(world_pos)
	)

func clear_tile_map_layer_selection() -> void:
	for c : Vector2i in world.tile_map_layer_selection.get_used_cells():
		if world.tile_map_layer_selection.get_cell_atlas_coords(c) != SELECTION_CELL:
			world.tile_map_layer_selection.set_cell(c)

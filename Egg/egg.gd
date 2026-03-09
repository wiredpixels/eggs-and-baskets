extends Node2D
class_name Egg

var speed = 30

@onready var sprite_2d: Sprite2D = $Sprite2D

var is_in_nest = false

func _physics_process(delta: float) -> void:
	var cell_type : Game.CellType = World.get_instance().get_current_cell_type(global_position)
	var current_cell = World.get_instance().get_current_cell(global_position)
	var cell_gp = World.get_instance().get_cell_global_position(current_cell)
	if cell_type == Game.CellType.NEST:
		print(global_position)
		print(global_position)
		global_position = global_position.move_toward(cell_gp, speed * delta)
		if global_position == cell_gp:
			if !validate_basket(current_cell):
				wrong_basket()
				return
			is_in_nest = true
			check_winning_condition()
	else:
		var dir : Vector2 = World.get_instance().get_block_direction(global_position)
		if dir == Vector2.ZERO:
			break_egg()
		else:
			if cell_type == Game.CellType.COLOR:
				if sprite_2d.modulate != World.get_instance().get_cell_color(current_cell):
					global_position = global_position.move_toward(cell_gp, speed * delta)
				if (global_position - cell_gp).length() <= 1:
					var color = World.get_instance().get_cell_color(current_cell)
					sprite_2d.modulate = color
			
			if dir == Vector2.RIGHT or dir == Vector2.LEFT:
				if global_position.y != cell_gp.y:
					global_position.y = move_toward(global_position.y, cell_gp.y, speed * delta)
				else:
					global_position.x += dir.x * speed * delta
			else:
				if global_position.x != cell_gp.x:
					global_position.x = move_toward(global_position.x, cell_gp.x, speed * delta)
				else:
					global_position.y += dir.y * speed * delta
	check_proximity()

func center_object(delta: float, dir : Vector2) -> void:
	var object_cell = World.get_instance().get_current_cell(global_position)
	var block_gp = World.get_instance().get_cell_global_position(object_cell)
	if dir == Vector2.RIGHT or dir == Vector2.LEFT:
		global_position.y = move_toward(global_position.y, block_gp.y, delta * speed)
	else:
		global_position.x = move_toward(global_position.x, block_gp.x, delta * speed)

func validate_basket(cell : Vector2i) -> bool:
	var basket_color = World.get_instance().get_cell_color(cell)
	if basket_color == Color.WHITE:
		return true
	else:
		return basket_color == sprite_2d.modulate

func break_egg() -> void:
	Game.game_over.emit(Game.GameOverReason.EGG_BROKEN)
	sprite_2d.frame = 2
	sprite_2d.modulate = Color.WHITE

func wrong_basket() -> void:
	Game.game_over.emit(Game.GameOverReason.WRONG_BASKET)

func check_winning_condition() -> void:
	for n in get_tree().get_nodes_in_group("egg"):
		if !n.is_in_nest:
			return
	Game.level_passed.emit()

func check_proximity() -> void:
	for e : Egg in get_tree().get_nodes_in_group("egg"):
		if e != self:
			if (e.global_position - global_position).length() <= 5:
				break_egg()
				e.break_egg()

extends Node

signal wistle
signal game_over(reason : GameOverReason)
signal level_passed

enum CellType {
	CONVEYOR,
	SPAWN,
	NEST,
	COLOR,
}

enum GameOverReason{
	EGG_BROKEN,
	WRONG_BASKET,
}

var current_level = 1

func reload_level() -> void:
	get_tree().reload_current_scene()

func next_level() -> void:
	current_level += 1
	reload_level()

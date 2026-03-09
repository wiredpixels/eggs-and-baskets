extends PanelContainer


func _ready() -> void:
	Game.level_passed.connect(_on_level_passed)
	visible = false

func _on_level_passed() -> void:
	if Game.current_level == 8:
		visible = true


func _on_button_pressed() -> void:
	Game.current_level = 1
	Game.reload_level()

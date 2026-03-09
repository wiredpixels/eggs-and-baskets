extends PanelContainer
@onready var label_passed: Label = $PanelContainer/MarginContainer/VBoxContainer/LabelPassed

func _ready() -> void:
	Game.level_passed.connect(_on_level_passed)
	visible = false
	label_passed.text = "Level " + str(Game.current_level) + " passed!"

func _on_level_passed() -> void:
	if Game.current_level < 8:
		visible = true


func _on_button_next_level_pressed() -> void:
	Game.next_level()


func _on_button_replay_level_pressed() -> void:
	Game.reload_level()

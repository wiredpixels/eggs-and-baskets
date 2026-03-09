extends PanelContainer
@onready var label_reason: Label = $MarginContainer/VBoxContainer/LabelReason

func set_reason(reason : Game.GameOverReason) -> void:
	match reason:
		Game.GameOverReason.EGG_BROKEN:
			label_reason.text = "Reason: Egg broken"
			label_reason.visible = true
		Game.GameOverReason.WRONG_BASKET:
			label_reason.text = "Reason: Wrong basket"
			label_reason.visible = true
		_:
			label_reason.text = ""
			label_reason.visible = false
			

func _on_button_retry_pressed() -> void:
	Game.reload_level()


func _on_button_new_game_pressed() -> void:
	Game.current_level = 1
	Game.reload_level()

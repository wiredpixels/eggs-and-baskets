extends PanelContainer

@onready var panel_container_reload: PanelContainer = $MarginContainer/HBoxContainer/PanelContainerReload
@onready var label_blow: Label = $LabelBlow

var first_time = true

func _ready() -> void:
	panel_container_reload.modulate.a = 0
	label_blow.visible = true

func _on_texture_button_whistle_pressed() -> void:
	if first_time:
		first_time = false
		panel_container_reload.modulate.a = 1
		label_blow.visible = false
	Game.wistle.emit()


func _on_texture_button_reload_pressed() -> void:
	if panel_container_reload.modulate.a == 1:
		Game.reload_level()

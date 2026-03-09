extends CanvasLayer

@onready var main_panel: PanelContainer = $MainPanel
@onready var game_over_panel: PanelContainer = $GameOverPanel
@onready var label_level: Label = $LabelLevel
@onready var label_hint: Label = $LabelHint
@onready var congratulations: PanelContainer = $Congratulations

func _ready() -> void:
	game_over_panel.visible = false
	Game.game_over.connect(_on_game_over)
	label_level.text = "Level " + str(Game.current_level)
	if Game.current_level > 1:
		label_hint.visible = false

func _process(delta: float) -> void:
	if !get_tree().paused:
		label_hint.visible = false

func _on_game_over(reason : Game.GameOverReason) -> void:
	game_over_panel.visible = true
	game_over_panel.set_reason(reason)
	main_panel.visible = false

func _on_level_passed() -> void:
	if Game.current_level == 8:
		congratulations.visible = true

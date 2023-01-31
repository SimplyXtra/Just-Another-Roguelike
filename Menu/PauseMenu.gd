extends Panel

onready var optionsMenu := $MarginContainer/HBoxContainer/OptionsMenu
signal pauseGame

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("uiPauseResume"):
		emit_signal("pauseGame")

func _on_ResumeButton_pressed() -> void:
	emit_signal("pauseGame")


func _on_OptionsButton_pressed() -> void:
	optionsMenu.visible = not optionsMenu.visible


func _on_RestartButton_pressed() -> void:
	emit_signal("pauseGame")
	stats.loadStartMenu()


func _on_QuitButton_pressed() -> void:
	get_tree().quit()

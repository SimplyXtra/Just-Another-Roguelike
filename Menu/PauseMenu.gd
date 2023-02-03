extends Panel

onready var optionsMenu := $MarginContainer/HBoxContainer/OptionsContainer/OptionsMenu
signal pauseGame

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("uiPauseResume"):
		optionsMenu.visible = false
		emit_signal("pauseGame")

func _on_ResumeButton_pressed() -> void:
	stats.changeSFX("LightButton")
	optionsMenu.visible = false
	emit_signal("pauseGame")


func _on_OptionsButton_pressed() -> void:
	stats.changeSFX("LightButton")
	optionsMenu.setSliderToCurrentDb()
	optionsMenu.visible = not optionsMenu.visible


func _on_RestartButton_pressed() -> void:
	stats.changeSFX("LightButton")
	emit_signal("pauseGame")
	stats.loadStartMenu()


func _on_QuitButton_pressed() -> void:
	stats.changeSFX("LightButton")
	get_tree().quit()

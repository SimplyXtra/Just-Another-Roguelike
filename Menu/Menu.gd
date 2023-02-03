extends PanelContainer


func _on_OptionsButton_pressed() -> void:
	stats.changeSFX("Button")
	var npcBoxes = $NPCBoxes
	npcBoxes.visible = not npcBoxes.visible
	var optionsMenu = $MarginContainer/VBoxContainer/Buffer/MarginContainer/OptionsMenu
	optionsMenu.visible = not npcBoxes.visible

func _on_StartButton_pressed() -> void:
	stats.changeSFX("Button")
	stats.playerHealth = stats.PLAYER_MAX_HEALTH
	stats.level = 0
	stats.changeSong("Bridge")
	stats.changeScene(stats.levels[stats.level])

func _on_QuitButton_pressed() -> void:
	stats.changeSFX("Button")
	get_tree().quit()

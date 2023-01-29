extends PanelContainer

func _on_OptionsButton_pressed() -> void:
	var NPCBoxes = $NPCBoxes
	NPCBoxes.visible = not NPCBoxes.visible

func _on_StartButton_pressed() -> void:
	stats.playerHealth = stats.PLAYER_MAX_HEALTH
	if stats.level == stats.levels.size() - 1:
		stats.level = 0
	if get_tree().change_scene(stats.levels[stats.level]):
		print("MenuChangeSceneError")

func _on_QuitButton_pressed() -> void:
	get_tree().quit()

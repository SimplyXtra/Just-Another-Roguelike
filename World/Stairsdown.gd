extends Area2D



func _on_Stairsdown_body_entered(_body: Node) -> void:
	stats.level += 1
	if stats.level < stats.levels.size():
		stats.changeScene(stats.levels[stats.level])
	else:
		stats.changeScene(stats.menu)
		stats.changeSong("Intro")

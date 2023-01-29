extends Area2D



func _on_Stairsdown_body_entered(_body: Node) -> void:
	stats.level += 1
	if get_tree().change_scene(stats.levels[stats.level]):
		print("ChangeLevelViaStairError")

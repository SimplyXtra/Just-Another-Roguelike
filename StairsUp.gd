extends Area2D



func _on_StairsUp_body_entered(_body: Node) -> void:
	stats.changeGlobalAnimation("transitionToMenu")

extends AnimatedSprite




func _on_Area2D_body_entered(_body: Node) -> void:
	stats.changeCrystals()
	#$AnimationPlayer.play("rippleDeath")
	queue_free()

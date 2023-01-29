extends Area2D

#Signals
signal damage(damage, knockback)

#Damage to parent
func takeDamage(damage:int, knockback:Vector2) -> void:
	emit_signal("damage", damage, knockback)

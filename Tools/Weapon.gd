extends Node2D

#Constants
export(int) var damage := 10
export(float) var knockbackForce := 100.0
export(String, "lightSwipe", "heavySwipe", "lunge") var animation := "lightSwipe"

#Globals
var knockback := Vector2.ZERO

#Nodes
onready var sprite := $Sprite
onready var animationPlayer := $AnimationPlayer
onready var hurtbox

#Signals
signal attackEnded

#Main
func attack(knockbackVector:Vector2) -> void:
	animationPlayer.play(animation)
	knockback = knockbackVector * knockbackForce

func dealDamage() -> void:
	var attacked : Array = hurtbox.get_overlapping_areas()
	for zeug in attacked:
		zeug.takeDamage(damage, knockback)#Do this later

func emitAttackOver() -> void:
	emit_signal("attackEnded")

func configureWeapon(isHostEnemy := false) -> void:
	if isHostEnemy:
		hurtbox = $hurtboxEnemy
		for i in range(4):
			hurtbox.set_collision_mask_bit(i, false)
		hurtbox.set_collision_mask_bit(1, true)
		hurtbox.set_collision_mask_bit(3, true)
	else:
		hurtbox = $hurtbox
		for i in range(4):
			hurtbox.set_collision_mask_bit(i, false)
		hurtbox.set_collision_mask_bit(2, true)
		hurtbox.set_collision_mask_bit(3, true)
	

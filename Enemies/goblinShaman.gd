extends "res://Enemies/enemy.gd"


func _ready() -> void:
	rng.randomize()
	var r = rng.randf_range(0, 1)
	var g = rng.randf_range(0, 1)
	var b = rng.randf_range(0, 1)
	cosmeticWeapon.modulate = Color(r, g, b)
	

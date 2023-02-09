extends "res://Enemies/enemy.gd"


export(String, "Red", "Blue", "Green", "Yellow") var crystalColor := "Red"
export(float) var glowSize := 1.0
export(int) var yOffset := 8
const glowEffects := {
	"Red" : {"Glow": preload("res://Items/GlowRed.tscn"), "Crystal" : preload("res://Items/CrystalRed.tscn")},
	"Blue" : {"Glow": preload("res://Items/GlowBlue.tscn"), "Crystal" : preload("res://Items/CrystalBlue.tscn")},
	"Green" : {"Glow": preload("res://Items/GlowGreen.tscn"), "Crystal" : preload("res://Items/CrystalGreen.tscn")},
	"Yellow" : {"Glow": preload("res://Items/GlowYellow.tscn"), "Crystal" : preload("res://Items/CrystalYellow.tscn")}
}


func _ready():
	var glow = (glowEffects[crystalColor].Glow.instance())
	glow.scale = Vector2(glowSize, glowSize)
	glow.show_behind_parent = true
	glow.position.y += yOffset
	add_child(glow)

func die() -> void:
	var crystal = glowEffects[crystalColor].Crystal.instance()
	get_parent().add_child(crystal)
	crystal.global_position = global_position
	crystal.global_position.y += yOffset
	
	.die()

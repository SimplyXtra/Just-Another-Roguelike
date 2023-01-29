extends Node

const PLAYER_MAX_HEALTH := 200
var playerHealth = PLAYER_MAX_HEALTH

const levels = [
	"res://Levels/Level_1.tscn",
	"res://Levels/Level_2.tscn",
	"res://Levels/Level_3.tscn",
	"res://Levels/Level_4.tscn",
	"res://Levels/Level_5.tscn",
	
	"res://MainScene.tscn"#End game screen
]
var level = 0

extends Node

const PLAYER_MAX_HEALTH := 200
var playerHealth = PLAYER_MAX_HEALTH

const menu = "res://MainScene.tscn"
const deathScene = "res://DeathScene.tscn"
const levels = [
	"res://Levels/Level_1.tscn",
	"res://Levels/Level_2.tscn",
	"res://Levels/Level_3.tscn",
	"res://Levels/Level_4.tscn",
	"res://Levels/Level_5.tscn"
]
var level = 0

signal changeScene(newScene)
signal changeSong(newSong)
signal changeHealth(damage)

func changeScene(path:String) -> void:
	emit_signal("changeScene", path)
func changeSong(songName:String) -> void:
	emit_signal("changeSong", songName)
func changeHealth(damage:int) -> void:
	playerHealth -= damage
	emit_signal("changeHealth", damage)

func loadStartMenu() -> void:
	changeScene(menu)
	changeSong("Intro")

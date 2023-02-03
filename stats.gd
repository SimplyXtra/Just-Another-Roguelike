extends Node

const PLAYER_MAX_HEALTH := 2
var playerHealth = PLAYER_MAX_HEALTH

const menu = "res://Menu/Menu.tscn"
const deathScene = "res://Levels/DeathLevel.tscn"
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
signal changeSFX(newSFX)
signal changeHealth(damage)
signal changeGlobalAnimation(newAnimation)

func changeScene(path:String) -> void:
	emit_signal("changeScene", path)
func changeSong(songName:String) -> void:
	emit_signal("changeSong", songName)
func changeSFX(sfxName:String) -> void:
	emit_signal("changeSFX", sfxName)
func changeHealth(damage:int) -> void:
	playerHealth -= damage
	emit_signal("changeHealth", damage)
func changeGlobalAnimation(newAnimation:String) ->void:
	emit_signal("changeGlobalAnimation", newAnimation)

func loadStartMenu() -> void:
	changeScene(menu)
	changeSong("Intro")

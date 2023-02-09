extends Node

const PLAYER_MAX_HEALTH := 200
var playerHealth := PLAYER_MAX_HEALTH

var crystalsHeld := 0

const menu := "res://Menu/Menu.tscn"
const deathScene := "res://Levels/DeathLevel.tscn"
const firstLevels := [
	"res://Levels/1.First Levels/Level 1.tscn", "res://Levels/1.First Levels/Level 2.tscn", "res://Levels/1.First Levels/Level 3.tscn"
]
const beginnerLevels := [
	"res://Levels/2.Beginner Levels/Level 4.tscn", "res://Levels/2.Beginner Levels/Level 5.tscn", "res://Levels/2.Beginner Levels/Level 6.tscn", "res://Levels/2.Beginner Levels/Level 7.tscn", "res://Levels/2.Beginner Levels/Level 8.tscn", "res://Levels/2.Beginner Levels/Level 9.tscn", "res://Levels/2.Beginner Levels/Level 10.tscn"
]
const extendedBeginnerLevels := [
	"res://Levels/3.Ext Beginner Levels/Level 11.tscn", "res://Levels/3.Ext Beginner Levels/Level 12.tscn", "res://Levels/3.Ext Beginner Levels/Level 13.tscn", "res://Levels/3.Ext Beginner Levels/Level 14.tscn", "res://Levels/3.Ext Beginner Levels/Level 15.tscn", "res://Levels/3.Ext Beginner Levels/Level 16.tscn", "res://Levels/3.Ext Beginner Levels/Level 17.tscn", "res://Levels/3.Ext Beginner Levels/Level 18.tscn"
]
const intermediateLevels := [
	"res://Levels/4.Intermediate Levels/Level 19.tscn", "res://Levels/4.Intermediate Levels/Level 20.tscn", "res://Levels/4.Intermediate Levels/Level 21.tscn", "res://Levels/4.Intermediate Levels/Level 22.tscn", "res://Levels/4.Intermediate Levels/Level 23.tscn", "res://Levels/4.Intermediate Levels/Level 24.tscn", "res://Levels/4.Intermediate Levels/Level 25.tscn", "res://Levels/4.Intermediate Levels/Level 26.tscn", "res://Levels/4.Intermediate Levels/Level 27.tscn", "res://Levels/4.Intermediate Levels/Level 28.tscn", "res://Levels/4.Intermediate Levels/Level 29.tscn", "res://Levels/4.Intermediate Levels/Level 30.tscn", "res://Levels/4.Intermediate Levels/Level 31.tscn", "res://Levels/4.Intermediate Levels/Level 32.tscn", "res://Levels/4.Intermediate Levels/Level 33.tscn"
]
const finalLevels := [
	"res://Levels/5.Final Levels/Level 34.tscn", "res://Levels/5.Final Levels/Level 35.tscn", "res://Levels/5.Final Levels/Level 36.tscn", "res://Levels/5.Final Levels/Level 37.tscn"
]
var levels := []
var levelsPath := []
var level := 0

signal changeScene(newScenePath, isOnlyString, newSceneResource)
signal changeSong(newSong)
signal changeSFX(newSFX)
signal changeHealth(damage)
signal changeGlobalAnimation(newAnimation)
signal crystalsChanged()

func changeScene(newScenePath:String, isOnlyString := true, newSceneResource = null) -> void:
	emit_signal("changeScene", newScenePath, isOnlyString, newSceneResource)
func changeSong(songName:String) -> void:
	emit_signal("changeSong", songName)
func changeSFX(sfxName:String) -> void:
	emit_signal("changeSFX", sfxName)
func changeHealth(damage:int) -> void:
	playerHealth -= damage
	emit_signal("changeHealth", damage)
func changeGlobalAnimation(newAnimation:String) ->void:
	emit_signal("changeGlobalAnimation", newAnimation)
func changeCrystals() -> void:
	crystalsHeld += 1
	emit_signal("crystalsChanged")

func loadStartMenu() -> void:
	changeScene(menu)
	changeSong("Intro")
func loadLevels() -> void:
	levels = []
	levelsPath = []
	firstLevels.shuffle()
	levelsPath.append(firstLevels[0])
	beginnerLevels.shuffle()
	for i in 4:
		levelsPath.append(beginnerLevels[i])
	extendedBeginnerLevels.shuffle()
	for i in 5:
		levelsPath.append(extendedBeginnerLevels[i])
	intermediateLevels.shuffle()
	for i in 9:
		levelsPath.append(intermediateLevels[i])
	finalLevels.shuffle()
	levelsPath.append(finalLevels[0])
	for scene in levelsPath:
		levels.append(load(scene))
func sum(x:Array)->int:
	var sum := 0
	for element in x:
		sum += element
	return sum

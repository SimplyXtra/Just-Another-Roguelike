extends Control

onready var musicPlayer := $MusicPlayer
onready var sfxPlayer := $SFXPlayer
var soundtrack = {
	"Intro" : preload("res://Music/Just Another Title Song.mp3"),
	"Bridge" : preload("res://Music/Just Another Bridge.mp3"),
	"Game" : preload("res://Music/Just Another Song.wav"),
	"Death": preload("res://Music/Just Another Sad Theme.wav")
}
var sfx = {
	"Button" : preload("res://Sound-Effects/Button.ogg"),
	"SliderHandle" : preload("res://Sound-Effects/Slider.ogg"),
	"LightButton" : preload("res://Sound-Effects/LightButton.ogg"),
	"PlayerDeath" : preload("res://Sound-Effects/Death.wav")
}
var playing = "Intro"

onready var GUI := $GUI
onready var pauseMenu := $GUI/PauseMenu
var isGamePaused = false
var loadedScene:Node
var loadedScenePath := ""

onready var animationPlayer = $AnimationPlayer

func _ready() -> void:
	if stats.connect("changeScene", self, "loadScene"): print("loadSceneConnectionError")
	if stats.connect("changeSong", self, "playSong"): print("changeSongConnectionError")
	if stats.connect("changeSFX", self, "playSFX"): print("changeSFXConnectionError")
	if stats.connect("changeHealth", self, "playerDamaged"): print("GUIplayerDamageError")
	if stats.connect("changeGlobalAnimation", self, "playAnimation"): print("AnimationConnectionError")
	if pauseMenu.connect("pauseGame", self, "pause"): print("pauseGameError")
	
	musicPlayer.play(0)
	loadScene("Menu/Menu.tscn")

func _on_MusicPlayer_finished() -> void:
	if playing == "Bridge":
		playSong("Game")
	musicPlayer.play(0)

func playerDamaged(_damage:int) -> void:
	if stats.playerHealth <= 0:
		AudioServer.set_bus_mute(1, true)
		animationPlayer.play("transitionToDeath")

func pause() -> void:
	if "Levels" in loadedScenePath: 
		isGamePaused = not isGamePaused
		if isGamePaused:
			pauseMenu.visible = true
			loadedScene.get_tree().paused = true
		else:
			pauseMenu.visible = false
			loadedScene.get_tree().paused = false

func playSong(songName:String) -> void:
	if songName in soundtrack:
		playing = songName
		musicPlayer.stop()
		musicPlayer.stream = soundtrack[playing]
		musicPlayer.play(0)

func playSFX(sfxName:String) -> void:
	if sfxName in sfx:
		sfxPlayer.stop()
		sfxPlayer.stream = sfx[sfxName]
		sfxPlayer.play(0)

func loadScene(path:String) -> void:
	if path != loadedScenePath:
		if not loadedScenePath:
			loadedScenePath = path
			loadedScene = load(path).instance()
			add_child(loadedScene)
		else:
			call_deferred("remove_child", loadedScene)
			loadedScenePath = path
			loadedScene = load(path).instance()
			call_deferred("add_child", loadedScene)
		#GUI.visible = "Levels" in path

func loadDeathScene() -> void:
	stats.playerHealth = 1
	AudioServer.set_bus_mute(1, false)
	playSong("Death")
	loadScene(stats.deathScene)

func loadMenu() -> void:
	stats.loadStartMenu()

func playAnimation(animationName:String) -> void:
	animationPlayer.play(animationName)

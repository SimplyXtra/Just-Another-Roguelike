extends Control

onready var musicPlayer := $MusicPlayer
onready var sfxPlayer := $SFXPlayer
var soundtrack = {
	"Intro" : preload("res://Music/Just Another Title Song.mp3"),
	"Bridge" : preload("res://Music/Just Another Bridge.mp3"),
	"Game" : preload("res://Music/Just Another Song.mp3"),
	"Death": preload("res://Music/Temp Death Song.mp3")
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
	if stats.connect("changeSong", self, "updateSong"): print("changeSongConnectionError")
	if pauseMenu.connect("pauseGame", self, "pause"): print("pauseGameError")
	musicPlayer.play(0)
	if stats.connect("changeHealth", self, "playerDamaged"): print("GUIplayerDamageError")
	musicPlayer.play(0)
	loadScene("Menu/Menu.tscn")

func _on_MusicPlayer_finished() -> void:
	if playing == "Bridge":
		updateSong("Game")
	musicPlayer.play(0)

func playerDamaged(_damage:int) -> void:
	if stats.playerHealth <= 0:
		AudioServer.set_bus_mute(1, true)
		animationPlayer.play("deathScreen")

func pause() -> void:
	if "Levels" in loadedScenePath: 
		isGamePaused = not isGamePaused
		if isGamePaused:
			pauseMenu.visible = true
			loadedScene.get_tree().paused = true
		else:
			pauseMenu.visible = false
			loadedScene.get_tree().paused = false

func updateSong(songName:String) -> void:
	if songName in soundtrack:
		playing = songName
		musicPlayer.stop()
		musicPlayer.stream = soundtrack[playing]
		musicPlayer.play(0)

func loadScene(path:String) -> void:
	if path != loadedScenePath:
		if not loadedScenePath:
			loadedScenePath = path
			loadedScene = load(path).instance()
			add_child(loadedScene)
		else:
			remove_child(loadedScene)
			loadedScenePath = path
			loadedScene = load(path).instance()
			call_deferred("add_child", loadedScene)
		#GUI.visible = "Levels" in path

func loadDeathScene() -> void:
	stats.playerHealth = 1
	AudioServer.set_bus_mute(1, false)
	updateSong("Death")
	loadScene(stats.deathScene)


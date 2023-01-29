extends Control

onready var musicPlayer = $MusicPlayer

func _on_MusicPlayer_finished() -> void:
	musicPlayer.play(0)


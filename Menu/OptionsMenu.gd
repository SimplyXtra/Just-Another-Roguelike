extends GridContainer

func _ready():
	var masterSlider = $MasterSlider
	masterSlider.value = db2linear(AudioServer.get_bus_volume_db(0))
	
	var musicSlider = $MusicSlider
	musicSlider.value = db2linear(AudioServer.get_bus_volume_db(1))
	
	var sfxSlider = $SFXSlider
	sfxSlider.value = db2linear(AudioServer.get_bus_volume_db(2))

func setBusVolume(busIndex:int, value:float) -> void:
	AudioServer.set_bus_volume_db(busIndex, linear2db(value))
	if value == 0:
		AudioServer.set_bus_mute(busIndex, true)
	else:
		AudioServer.set_bus_mute(busIndex, false)

func _on_MasterSlider_value_changed(value: float) -> void:
	setBusVolume(0, value)


func _on_MusicSlider_value_changed(value: float) -> void:
	setBusVolume(1, value)


func _on_SFXSlider_value_changed(value: float) -> void:
	setBusVolume(2, value)

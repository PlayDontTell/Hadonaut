extends Sprite


onready var current_chapter = get_node("../../../..")


func _on_SoundSlider_value_changed(value):
	$SoundCross.visible = value == 0
	$MusicCross.visible = value == 0 and not $MusicSlider.value == 0
	$FxCross.visible = value == 0 and not $FxSlider.value == 0
	AudioServer.set_bus_volume_db(0, value * 6 - 48)
	$SoundSliderCheck.play()


func _on_MusicSlider_value_changed(value):
	$MusicCross.visible = value == 0
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), value * 6 - 48)
	$MusicSliderCheck.play()
	
	
func _on_FxSlider_value_changed(value):
	$FxCross.visible = value == 0
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Fx"), value * 6 - 48)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Atmo"), value * 6 - 48)
	$FxSliderCheck.play()


func _on_BrightnessSlider_value_changed(value):
	current_chapter.environment.set_adjustment_brightness(0.4 + value * 0.12)
	$SoundSliderCheck.play()


func _on_ContrastSlider_value_changed(value):
	current_chapter.environment.set_adjustment_contrast(0.9 + value * 0.02)
	$SoundSliderCheck.play()

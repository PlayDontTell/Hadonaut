extends HSlider


export var default_value: int


func _on_Reset_pressed():
	value = default_value
	$ResetSound.play()

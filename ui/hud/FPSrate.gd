extends Label


# warning-ignore:unused_argument
func _process(delta):
	text = str(Performance.get_monitor(Performance.TIME_FPS))

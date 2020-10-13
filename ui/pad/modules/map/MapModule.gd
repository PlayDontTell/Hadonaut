extends Node2D


var _timer = null


func _ready():
	_timer = Timer.new()
	add_child(_timer)

	_timer.connect("timeout", self, "_on_Timer_timeout")
	_timer.set_wait_time(4.0)
	_timer.set_one_shot(false) # Make sure it loops
	_timer.start()
	

func _on_Timer_timeout():
# warning-ignore:unused_variable
	for i in range(16):
		yield(get_tree().create_timer(0.02), "timeout")
		material.set_shader_param("amount", rand_range(0, 0.2))
	material.set_shader_param("amount", 0)


func _on_PadSprite_hslider_moved(value):
	$ShipInHidden.modulate = Color(1, 1, 1, value)


func _on_PadSprite_vslider_moved(value):
	$ShipOut.modulate = Color(1, 1, 1, value)

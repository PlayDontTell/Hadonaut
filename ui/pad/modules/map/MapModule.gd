extends Control


var _timer = null


func _on_PadSprite_hslider_moved(value):
	$ShipInHidden.modulate = Color(1, 1, 1, value)


func _on_PadSprite_vslider_moved(value):
	$ShipOut.modulate = Color(1, 1, 1, value)

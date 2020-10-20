extends AnimatedSprite


var default_modulate: Color


func _on_Area2D_area_entered(area):
	if area.is_in_group("cursor"):
		default_modulate = modulate
		modulate = Global.COLOR_DEFAULT


func _on_Area2D_area_exited(area):
	if area.is_in_group("cursor"):
		modulate = default_modulate

extends Sprite


var default_modulate: Color


func _on_GoToCryopod_area_entered(area):
	if area.is_in_group("cursor"):
		default_modulate = modulate
		modulate = Global.highlight_tint


func _on_GoToCryopod_area_exited(area):
	if area.is_in_group("cursor"):
		modulate = default_modulate

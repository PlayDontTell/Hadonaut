extends Sprite


var default_modulate: Color


func _on_RightArea2D_area_entered(area):
	if area.is_in_group("cursor"):
		default_modulate = self_modulate
		self_modulate = Global.highlight_tint


func _on_RightArea2D_area_exited(area):
	if area.is_in_group("cursor"):
		self_modulate = default_modulate

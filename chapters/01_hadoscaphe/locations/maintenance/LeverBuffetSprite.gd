extends Sprite


var default_modulate: Color


func _on_ToLeverbuffet_area_entered(area):
	if area.is_in_group("cursor"):
		default_modulate = self_modulate
		self_modulate = Global.highlight_tint
		$LeverBuffet_LeftDoor.self_modulate = Global.highlight_tint
		$LeverBuffet_RightDoor.self_modulate = Global.highlight_tint


func _on_ToLeverbuffet_area_exited(area):
	if area.is_in_group("cursor"):
		self_modulate = default_modulate
		$LeverBuffet_LeftDoor.self_modulate = default_modulate
		$LeverBuffet_RightDoor.self_modulate = default_modulate

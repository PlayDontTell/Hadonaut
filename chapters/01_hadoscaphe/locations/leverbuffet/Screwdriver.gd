extends Area2D


var default_modulate: Color


func _on_Screwdriver_area_entered(area):
	if area.is_in_group("cursor"):
		default_modulate = $Sprite.self_modulate
		$Sprite.self_modulate = Global.highlight_tint


func _on_Screwdriver_area_exited(area):
	if area.is_in_group("cursor"):
		$Sprite.self_modulate = default_modulate

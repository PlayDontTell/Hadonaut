extends Area2D


onready var room = get_node("..")

var default_modulate: Color


# warning-ignore:unused_argument
# warning-ignore:unused_argument
func _on_MapModuleInstance_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed:
		room.current_chapter.map_module_taken = true
		visible = false
		$CollisionPolygon2D.disabled = true
		room.inventory.add("map_module", Vector2(376, 142))
		Global.add_to_playthrough_progress("You took the map module.")
		


func _on_MapModuleInstance_area_entered(area):
	if area.is_in_group("cursor"):
		default_modulate = $Sprite.self_modulate
		$Sprite.self_modulate = Global.highlight_tint


func _on_MapModuleInstance_area_exited(area):
	if area.is_in_group("cursor"):
		$Sprite.self_modulate = default_modulate

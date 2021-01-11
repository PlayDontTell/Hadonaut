extends Area2D


onready var room = get_node("..")

var default_modulate: Color


# warning-ignore:unused_argument
# warning-ignore:unused_argument
func _on_PadInstance_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed:
		room.current_chapter.pad_taken = true
		$CollisionPolygon2D.disabled = true
		room.hud.drawers.setup_pad()
		Global.add_to_playthrough_progress("You took the pad.")
		room.get_node("Tween").interpolate_property(self, "modulate", modulate, Global.COLOR_TRANPARENT, 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN)
		room.get_node("Tween").start()
		yield(get_tree().create_timer(0.5), "timeout")
		visible = false


func _on_PadInstance_area_entered(area):
	if area.is_in_group("cursor"):
		default_modulate = $Sprite.self_modulate
		$Sprite.self_modulate = Global.highlight_tint


func _on_PadInstance_area_exited(area):
	if area.is_in_group("cursor"):
		$Sprite.self_modulate = default_modulate

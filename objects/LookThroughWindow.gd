extends Area2D


export var flip_h: bool
var is_mouse_overlapping: bool = false


func _on_LookThroughWindow_mouse_entered():
	is_mouse_overlapping = true


func _on_LookThroughWindow_mouse_exited():
	is_mouse_overlapping = false


# warning-ignore:unused_argument
# warning-ignore:unused_argument
func _on_LookThroughWindow_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed:
		if is_mouse_overlapping:
			var position_ordered = $PointToWindow.position + position
			var action = get_node("../Char").execute_action("window", position_ordered, flip_h, "idle")
			yield(action, "completed")
			if get_node("../Char").action == "window_completed":
				get_node("../..").go_to_room("window")

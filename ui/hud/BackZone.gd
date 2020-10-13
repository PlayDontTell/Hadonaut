extends Area2D


export var to_room: String


# warning-ignore:unused_argument
# warning-ignore:unused_argument
func _on_BackZone_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed:
		get_node("../..").go_to_room(to_room)

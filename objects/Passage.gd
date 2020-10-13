extends Area2D


export var to_room: String
export var room_without_char: bool
export var to_x: int
export var to_y: int
export var flip_h: bool
var is_mouse_overlapping: bool = false


func _on_Passage_mouse_entered():
	is_mouse_overlapping = true


func _on_Passage_mouse_exited():
	is_mouse_overlapping = false


func _on_Passage_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.pressed:
		if is_mouse_overlapping:
			var position_ordered = $PointToRoom.position + position
			var action = get_node("../Char").execute_action(to_room, position_ordered, flip_h, "idle")
			yield(action, "completed")
			if get_node("../Char").action == to_room + "_completed":
				if not room_without_char:
					get_node("../..").go_to_room(to_room, flip_h, to_x, to_y)
				else:
					get_node("../..").go_to_room(to_room)

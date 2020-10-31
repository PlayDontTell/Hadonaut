extends Area2D


export var to_room: String
export var action_type = "idle"

var mouse_on_zone: bool


func _unhandled_input(event):
	if (event is InputEventMouseButton and event.pressed 
	and mouse_on_zone and Global.mouse_hovering_count == 0):
		get_node("../..").go_to_room(to_room, Global.last_flip_h, Global.last_x, Global.last_y, action_type)


func _on_BackZone_mouse_entered():
	mouse_on_zone = true


func _on_BackZone_mouse_exited():
	mouse_on_zone = false


# warning-ignore:unused_argument
# warning-ignore:unused_argument
# warning-ignore:unused_argument
func _on_BackZone_input_event(viewport, event, shape_idx):
	pass # Replace with function body.

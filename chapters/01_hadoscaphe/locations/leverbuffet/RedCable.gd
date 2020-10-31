extends Line2D


var is_pin_picked: bool = false
var is_mouse_out_area: bool = false


func _ready():
	for node in get_tree().get_nodes_in_group("pickable"):
		node.connect("clicked", self, "_on_pickable_clicked")


# warning-ignore:unused_argument
func _process(delta):
	points[1] = $RedPin.position


func _unhandled_input(event):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT:
		if held_object and !event.pressed:
			held_object.drop(Input.get_last_mouse_speed())
			held_object = null

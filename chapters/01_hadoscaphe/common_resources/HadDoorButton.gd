extends Area2D


signal order_interaction(action_name, position_ordered, flip_h, action_type)


export var action_name: String
export var action_type: String
export var flip_h: bool = false
export var door_id: int
var is_active: bool = false
var default_modulate: Color

onready var current_room = get_node("..")


# warning-ignore:unused_argument
# warning-ignore:unused_argument
func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			var position_ordered: Vector2 = position + $PointOfInteraction.position
			var action_offset: Vector2
			match action_type:
				"push":
					action_offset = Vector2(11, 20)
				"pick":
					action_offset = Vector2(9, 1)
			if flip_h:
				position_ordered.x = round(position_ordered.x) + action_offset.x
			else:
				position_ordered.x = round(position_ordered.x) - action_offset.x
			position_ordered.y = round(position_ordered.y) + action_offset.y
			
			emit_signal("order_interaction", action_name, position_ordered, flip_h, action_type)


func set_state():
	is_active = current_room.current_chapter.had_doors[door_id][0]
	var animation = "on" if is_active else "off"
	$Animation.play(animation)


func _on_HadDoorButton_area_entered(area):
	if area.is_in_group("cursor"):
		default_modulate = modulate
		modulate = Global.highlight_tint

func _on_HadDoorButton_area_exited(area):
	if area.is_in_group("cursor"):
		modulate = default_modulate

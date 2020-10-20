extends Area2D


signal order_interaction(action_name, position_ordered, flip_h, action_type)

export var action_name: String
export var action_type: String
export var flip_h: bool = false
var default_modulate: Color

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



func _on_InteractiveObject_area_entered(area):
	if area.is_in_group("cursor"):
		default_modulate = modulate
		modulate = Global.COLOR_HIGHLIGHT


func _on_InteractiveObject_area_exited(area):
	if area.is_in_group("cursor"):
		modulate = default_modulate

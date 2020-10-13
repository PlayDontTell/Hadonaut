extends Area2D


signal ready_for_long_action_effects
signal long_action_started
signal long_action_stopped


export var needed_item: String = ""

var mouse_on_object: bool = false


# warning-ignore:unused_argument
func _process(delta):
	if (mouse_on_object and Global.cursor_animation == "long_action"
		and (needed_item == "" or GlobalInventory.item_used == needed_item)):
			emit_signal("long_action_started")
			if Global.cursor_animation_frame >= 0.9:
				emit_signal("ready_for_long_action_effects")
	else:
		emit_signal("long_action_stopped")


func _on_LongActionObject_area_entered(area):
	if area.is_in_group("cursor"):
		mouse_on_object = true
		if needed_item == "" or (GlobalInventory.item_used == needed_item):
			Global.mouse_hovering_long_action = true


func _on_LongActionObject_area_exited(area):
	if area.is_in_group("cursor"):
		mouse_on_object = false
		Global.mouse_hovering_long_action = false

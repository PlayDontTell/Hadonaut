extends Node2D


onready var current_chapter = get_node("..")


func _input(event):
	if event is InputEventKey:
		if Global.DEV_MODE:
			if Input.is_key_pressed(KEY_F5) and not event.echo:
# warning-ignore:return_value_discarded
				get_tree().reload_current_scene()
			if Input.is_key_pressed(KEY_F4) and not event.echo:
				var state = current_chapter.ship_power
				if state == "day":
					current_chapter.set_ship_power("night")
				else:
					current_chapter.set_ship_power("day")

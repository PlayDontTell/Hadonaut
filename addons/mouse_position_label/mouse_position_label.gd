tool
extends EditorPlugin

var dock

func _enter_tree():
	dock = preload("res://addons/mouse_position_label/MousePositionLabel.tscn").instance()
	add_control_to_dock(DOCK_SLOT_RIGHT_BL, dock)

func _input(event):
	var scene_root = get_tree().get_edited_scene_root()
	if not scene_root is WorldEnvironment and not scene_root == null:
		var mouse_coords = scene_root.get_global_mouse_position()
		mouse_coords.x = int(mouse_coords.x)
		mouse_coords.y = int(mouse_coords.y)
		dock.text = str(mouse_coords)

func _exit_tree():
	remove_control_from_docks(dock)
	dock.free()

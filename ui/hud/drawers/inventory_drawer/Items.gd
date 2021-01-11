extends Node2D


func _input(event):
	var state = GlobalInventory.is_using_item
	if event is InputEventMouseButton and event.pressed and Global.mouse_hovering_inventory:
		for item in get_children():
			yield(get_tree(), "idle_frame")
			if state:
				if item.item_name == GlobalInventory.item_used:
					item.holster_item()
			else:
				if item.item_name == GlobalInventory.item_hovered:
					item.draw_item()

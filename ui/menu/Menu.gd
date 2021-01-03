extends Node2D

onready var ui = get_node("..")
onready var current_chapter = ui.get_node("..")
var mouse_on_menu: bool


func empty_hands():
	if GlobalInventory.is_using_item:
		for item_element in ui.get_node("Inventory/Items").get_children():
			if item_element.item_name == GlobalInventory.item_used:
				item_element.get_node("ItemTexture").visible = true

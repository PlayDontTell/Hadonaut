extends Node


# List of the items of the game.
var existing_items: Array = [
		# Item Null.
		"fresh_air",
		# Key to trap of the cryopod room (hadoscaphe), first item of the game.
		"cryopod_trap_key",
		# Flat head screwdriver.
		"screwdriver",
		# Slider key for the pad.
		"pad_slider",
		# Map module for the pad, found with the pad.
		"map_module",
		# GPS item, description not yet complete.
		"gps",
		]
# Inventory of Char.
var char_inventory: Array = []
var is_using_item: bool
var item_used: String = ""
var item_hovered: String = ""


# First setter function of the inventory: add an item by name.
func add(item):
	if item in existing_items:
		if not item in char_inventory:
			char_inventory.append(item)
			print(item + " added to the inventory of Char.")
		else:
			print(item + " is already in the inventory.")
	else:
		print(item + " does'nt exist.")


# Second setter function of the inventory: remove an item by name.
func remove(item):
	if item in existing_items:
		if item in char_inventory:
			char_inventory.remove(char_inventory.find(item))
			print(item + " removed from the inventory of Char.")
		else:
			print(item + " isn't in the inventory, it cannot be removed it from the inventory of Char.")
	else:
		print(item + " does'nt exist.")


func place(id, item):
	char_inventory.insert(id, item)

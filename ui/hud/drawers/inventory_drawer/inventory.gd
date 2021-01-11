extends Node2D


var item_spawn_positions = {}

onready var item_scene = preload("res://ui/items/Item.tscn")
onready var drawer = get_node("..")
onready var handle = drawer.get_node("InventoryHandle")
onready var hud = drawer.get_node("..")

var left_inventory_margin: int = 66


func _ready():
	refresh()


func refresh():
	# Getting rid of the removed items.
	for n in $Items.get_children():
		if not n.item_name in GlobalInventory.char_inventory:
			$Items.remove_child(n)
			n.queue_free()
	# Creating the new items in the inventory, and initializing them.
	for item_element in GlobalInventory.char_inventory:
		var item_exists = false
		for n in $Items.get_children():
			if n.item_name == item_element:
				item_exists = true
		if not item_exists:
			var item_instance = item_scene.instance()
			item_instance.item_name = item_element
			if item_spawn_positions.has(item_instance.item_name):
				item_instance.item_spawn_position = item_spawn_positions.get(item_instance.item_name)
			$Items.add_child(item_instance)
	# Initializing the items that already exist.
	for n in $Items.get_children():
		n.item_id = GlobalInventory.char_inventory.find(n.item_name)
		n.item_default_position = Vector2(left_inventory_margin + 32 * n.item_id, 0)
		n.rect_position = n.item_default_position
	# Making sure that no items is being used after the process
	GlobalInventory.is_using_item = false
	GlobalInventory.item_used = ""


func add(item, spawn_position = Vector2(0, 0)):
	GlobalInventory.add(item)
	item_spawn_positions[item] = spawn_position - position - Vector2(left_inventory_margin, 0)
	refresh()
	$BagSound.play()


func remove(item):
	GlobalInventory.remove(item)
	refresh()


func holster(item):
	var id = GlobalInventory.char_inventory.find(item)
	GlobalInventory.remove(item)
	refresh()
	GlobalInventory.place(id, item)
	refresh()
	$BagSound.play()

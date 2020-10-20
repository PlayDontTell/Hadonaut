extends Node2D

onready var ui = get_node("..")
onready var current_chapter = ui.get_node("..")
var mouse_on_menu: bool


func _ready():
	$MenuFrame.visible = false
	Global.menu_visible = false
	$OutOfMenu.visible = false
	$InMenu.visible = false


func _on_MenuButton_pressed():
	toggle_menu()
	empty_hands()


func _on_inMenu_mouse_entered():
	mouse_on_menu = true


func _on_inMenu_mouse_exited():
	mouse_on_menu = false


func _on_OutOfSettings_pressed():
	if not mouse_on_menu and Global.menu_visible and get_tree().paused:
		toggle_menu()
		empty_hands()


func toggle_menu():
	var state = Global.menu_visible
	$MenuFrame.visible = not state
	Global.menu_visible = not state
	$OutOfMenu.visible = not state
	$InMenu.visible = not state
	$MenuFrame/WindowTab.visible = false
	$MenuFrame/WindowTabButton.pressed = false
	if state and not Global.pad_visible:
		Global.toggle_pause_off()
	if not state:
		Global.toggle_pause_on()
	$MenuClick.play()


func _on_MenuButton_mouse_entered():
	Global.mouse_hovering_count += 1
	Global.force_menu_cursor = true


func _on_MenuButton_mouse_exited():
	if Global.mouse_hovering_count > 0:
		Global.mouse_hovering_count -= 1
	Global.force_menu_cursor = false


func empty_hands():
	if GlobalInventory.is_using_item:
		for item_element in ui.get_node("Inventory/Items").get_children():
			if item_element.item_name == GlobalInventory.item_used:
				item_element.get_node("ItemTexture").visible = true

extends Node2D

var menu_drawer_opened: bool = false
var pad_drawer_opened: bool = false
var inventory_drawer_opened: bool = false
var inventory_drawer_size: int = 0


func _on_PadHandle_opened():
	Global.toggle_pause_on()
	pad_drawer_opened = true
	move_child($PadDrawer, 1)
	if $PadDrawer/PadHandle.sleeping:
		$InventoryDrawer/InventoryHandle.MAX_X = 69
		$InventoryDrawer/InventoryHandle.blocked_by_pad_drawer = true


func _on_PadHandle_closed():
	pad_drawer_opened = false
	$InventoryDrawer/InventoryHandle.MAX_X = 432
	$InventoryDrawer/InventoryHandle.blocked_by_pad_drawer = false
	drawers_closed_pause()


func _on_MenuHandle_opened():
	Global.toggle_pause_on()
	menu_drawer_opened = true
	Global.force_menu_cursor = true


func _on_MenuHandle_closed():
	menu_drawer_opened = false
	drawers_closed_pause()
	Global.force_menu_cursor = false


func _on_InventoryHandle_opened(position):
	if position == "item_bar":
		inventory_drawer_size = 1
		drawers_closed_pause()
		$PadDrawer/PadHandle.MIN_Y = 7
		$PadDrawer/PadHandle.blocked_by_inventory_drawer = false
	if position == "full":
		inventory_drawer_size = 2
		Global.toggle_pause_on()
		move_child($InventoryDrawer, 1)
		if $InventoryDrawer/InventoryHandle.sleeping:
			$PadDrawer/PadHandle.MIN_Y = 224
			$PadDrawer/PadHandle.blocked_by_inventory_drawer = true
	inventory_drawer_opened = true


func _on_InventoryHandle_closed():
	inventory_drawer_size = 0
	inventory_drawer_opened = false
	$PadDrawer/PadHandle.MIN_Y = 7
	$PadDrawer/PadHandle.blocked_by_inventory_drawer = false
	drawers_closed_pause()


func drawers_closed_pause():
	if not inventory_drawer_size == 2 and not pad_drawer_opened and not menu_drawer_opened:
		Global.toggle_pause_off()

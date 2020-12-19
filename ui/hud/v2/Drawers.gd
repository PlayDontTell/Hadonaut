extends Node2D

var menu_drawer_opened: bool = false
var pad_drawer_opened: bool = false
var inventory_drawer_opened: bool = false
var inventory_drawer_size: int = 0


func _on_PadHandle_opened():
	pad_drawer_opened = true
	move_child($PadDrawer, 1)
	if $PadDrawer/PadHandle.sleeping:
		$InventoryDrawer/InventoryHandle.MAX_X = 69
		$InventoryDrawer/InventoryHandle.blocked_by_pad_drawer = true


func _on_PadHandle_closed():
	pad_drawer_opened = false
	$InventoryDrawer/InventoryHandle.MAX_X = 432
	$InventoryDrawer/InventoryHandle.blocked_by_pad_drawer = false


func _on_InventoryHandle_opened(position):
	if position == "item_bar":
		inventory_drawer_size = 1
		$PadDrawer/PadHandle.MIN_Y = 7
		$PadDrawer/PadHandle.blocked_by_inventory_drawer = false
	if position == "full":
		inventory_drawer_size = 2
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

extends Node2D


func _on_PadHandle_opened():
	Global.toggle_pause_on()
	Global.pad_drawer_opened = true
	
	if $PadDrawer/PadHandle.sleeping:
		$InventoryDrawer/InventoryHandle.MAX_Y = 199
		$InventoryDrawer/InventoryHandle.blocked_by_pad_drawer = true


func _on_PadHandle_closed():
	Global.pad_drawer_opened = false
	
	$InventoryDrawer/InventoryHandle.MAX_Y = 35
	$InventoryDrawer/InventoryHandle.blocked_by_pad_drawer = false
	drawers_closed_pause()


func _on_InventoryHandle_opened():
	Global.toggle_pause_on()
	if $InventoryDrawer/InventoryHandle.sleeping:
		$PadDrawer/PadHandle.MIN_Y = 45
		$PadDrawer/PadHandle.blocked_by_inventory_drawer = true
	Global.inventory_drawer_opened = true


func _on_InventoryHandle_closed():
	Global.inventory_drawer_opened = false
	$PadDrawer/PadHandle.MIN_Y = 212
	$PadDrawer/PadHandle.blocked_by_inventory_drawer = false
	drawers_closed_pause()


func drawers_closed_pause():
	if not Global.inventory_drawer_opened and not Global.pad_drawer_opened:
		Global.toggle_pause_off()


func setup_pad():
	Global.disable_input(1.8)
	$PadDrawer/PadHandle.set_global_transform_origin_y(-10)
	$PadDrawer.visible = true
	
	$InventoryDrawer/InventoryHandle.MAX_Y = 199
	$InventoryDrawer/InventoryHandle.blocked_by_pad_drawer = true
	
	$PadDrawer/PadHandle.set_static(false)
	$Tween.interpolate_method($PadDrawer/PadHandle, "set_global_transform_origin_y",
							 -10, 213, 1.8, Tween.TRANS_QUINT,Tween.EASE_IN_OUT)
	$Tween.start()
	yield(get_tree().create_timer(0.4), "timeout")
	$SlidingSound.play()


func setup_inventory():
	Global.disable_input(2.3)
	$PadDrawer/PadHandle.MIN_Y = 45
	$PadDrawer/PadHandle.blocked_by_inventory_drawer = true
	
	$InventoryDrawer.visible = true
	yield(get_tree().create_timer(0.5), "timeout")
	$InventoryDrawer/InventoryHandle.set_static(false)
	$Tween.interpolate_method($InventoryDrawer/InventoryHandle, "set_global_transform_origin_y",
							 280, 35, 1.8, Tween.TRANS_QUINT,Tween.EASE_IN_OUT)
	$Tween.start()
	yield(get_tree().create_timer(0.4), "timeout")
	
	$SlidingSound.play()

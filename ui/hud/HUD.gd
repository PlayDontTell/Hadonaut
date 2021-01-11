extends Node2D


onready var inventory = $Drawers/InventoryDrawer/Inventory
onready var inventory_handle = $Drawers/InventoryDrawer/InventoryHandle
onready var inventory_drawer = $Drawers/InventoryDrawer
onready var drawers = $Drawers
onready var pad_drawer = $Drawers/PadDrawer
onready var pad = $Drawers/PadDrawer/Pad
onready var current_chapter = get_node("..")


func _ready():
	if not Global.DEV_MODE:
		$FPSrate.free()
	$Drawers/PadDrawer.visible = current_chapter.pad_taken
	
	if not current_chapter.inventory_taken:
		inventory_handle.set_global_transform_origin_y(270)
		inventory_handle.mode = RigidBody2D.MODE_STATIC
		inventory_drawer.visible = false


# warning-ignore:unused_argument
func _process(delta):
	if Global.all_has_been_seen and not $EndOfContentScreen.has_been_displayed:
		$EndOfContentScreen.draw()


func _unhandled_input(event):
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


func _on_MenuButton_mouse_entered():
	Global.mouse_hovering_count += 1


func _on_MenuButton_mouse_exited():
	if Global.mouse_hovering_count > 0:
		Global.mouse_hovering_count -= 1


func _on_MenuButton_button_down():
	$MenuButton/ButtonDown.play()


func _on_MenuButton_button_up():
	$MenuButton/ButtonUp.play()
	$Menu.visible = not $Menu.visible
	Global.menu_visible = true
	Global.toggle_pause_on()

extends Node2D


onready var fade = get_node("../../Fade")
onready var pad_handle = get_node("../PadDrawer/PadHandle")
onready var inventory_handle = get_node("../InventoryDrawer/InventoryHandle")
var insert_pos_1: int = -382
var last_ratio: float
var ratio_margin : float = 0.05
var ratio: float = 0.0
var shade_intensity: float = 1.0


# warning-ignore:unused_argument
func set_elements():
	# Using the position of the handle as a base for the position of the rest of the drawer.
	var handle_pos = $MenuHandle.position
	
	var start_to_end = abs($Start.position.x - $End.position.x)
	if handle_pos.x <= $Start.position.x - start_to_end * ratio_margin:
		ratio = stepify(abs(($Start.position.x - start_to_end * ratio_margin - handle_pos.x) / 
			(start_to_end * (1 - ratio_margin))), 0.01)
	else:
		ratio = 0.0
	
	if ratio != last_ratio:
		fade.modulate = Color(1, 1, 1, ratio * shade_intensity)
		if pad_handle.sticked_opened:
			pad_handle.set_to_position_ratio(ratio)
		if not inventory_handle.sticked_opened == 0:
			inventory_handle.set_to_position_ratio(ratio)
		pad_handle.is_handle_disabled = ratio > ratio_margin
		inventory_handle.is_handle_disabled = ratio > ratio_margin
		last_ratio = ratio
	
	$Shade.modulate = Color(1, 1, 1, ratio * shade_intensity * 0.75)
	var ratio_modulate = 1 - ratio * shade_intensity * 0.75
	get_node("../../Foreground").modulate = Color(ratio_modulate, ratio_modulate, ratio_modulate)
	
	# Animation of the drawer pieces.
	var frame = ($Start.position.x - handle_pos.x) / ($Start.position.x - $End.position.x) * 24
	$Corner1.frame = frame
	$Corner2.frame = frame
	$EndTile.frame = frame
	
	var frame_insert_1 = (($Start.position.x - (handle_pos.x - insert_pos_1)) / 
		($Start.position.x - $End.position.x) * 24)
		
	$Insert1.frame = frame_insert_1
	$Insert2.frame = frame_insert_1
	$InsertTile.frame = frame_insert_1
	
	# Position of the drawer pieces.
	var drawer_pos = floor(handle_pos.x - 8 - frame / 2.6)
	$Corner1.position.x = drawer_pos
	$Corner2.position.x = drawer_pos
	$Insert1.position.x = drawer_pos - insert_pos_1
	$Insert2.position.x = drawer_pos - insert_pos_1
	$EndTile.position.x = drawer_pos
	$InsertTile.position.x = drawer_pos - insert_pos_1
	$InteriorTile.position.x = drawer_pos + 18
	$Menu.position.x = drawer_pos - 76
	
	# When the drawer passes the middle of the screen,
	#	the handle gets behind or in front of the other drawer pieces.
	if handle_pos.x <= ($Start.position.x - $End.position.x) / 2 + $End.position.x:
		if $MenuHandle.get_index() != 1:
			move_child($MenuHandle, 1)
	else:
		if $MenuHandle.get_index() != 12:
			move_child($MenuHandle, 12)

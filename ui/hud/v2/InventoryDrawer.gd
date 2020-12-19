extends Node2D


var insert_pos_1: int = 37
var insert_pos_2: int = 413


# warning-ignore:unused_argument
func set_elements():
	# Using the position of the handle as a base for the position of the rest of the drawer.
	var handle_pos = $InventoryHandle.position
	
	# Animation of the drawer pieces.
	var frame = ($Start.position.x - handle_pos.x) / ($Start.position.x - $End.position.x) * 24
	$Corner1.frame = frame
	$Corner2.frame = frame
	$EndTile.frame = frame
	
	var frame_insert_1 = ($Start.position.x - (handle_pos.x - insert_pos_1)) / ($Start.position.x - $End.position.x) * 24
	$Insert1.frame = frame_insert_1
	$Insert2.frame = frame_insert_1
	$InsertTile.frame = frame_insert_1
	
	var frame_insert_2 = ($Start.position.x - (handle_pos.x - insert_pos_2)) / ($Start.position.x - $End.position.x) * 24
	$Insert3.frame = frame_insert_2
	$Insert4.frame = frame_insert_2
	$InsertTile2.frame = frame_insert_2
	
	# Position of the drawer pieces.
	var drawer_pos = floor(handle_pos.x - 6 + frame / 2.6)
	$Corner1.position.x = drawer_pos
	$Corner2.position.x = drawer_pos
	$Insert1.position.x = drawer_pos - insert_pos_1
	$Insert2.position.x = drawer_pos - insert_pos_1
	$Insert3.position.x = drawer_pos - insert_pos_2
	$Insert4.position.x = drawer_pos - insert_pos_2
	$EndTile.position.x = drawer_pos
	$InsertTile.position.x = drawer_pos - insert_pos_1
	$InsertTile2.position.x = drawer_pos - insert_pos_2
	$InteriorTile.position.x = drawer_pos - 18
	
	# When the drawer passes the middle of the screen,
	#	the handle gets behind or in front of the other drawer pieces.
	if handle_pos.x <= ($Start.position.x - $End.position.x) / 2 + $End.position.x:
		if $InventoryHandle.get_index() != 12:
			move_child($InventoryHandle, 12)
	else:
		if $InventoryHandle.get_index() != 0:
			move_child($InventoryHandle, 0)

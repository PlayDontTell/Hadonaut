extends Node2D


var insert_pos_1: int = -242


# warning-ignore:unused_argument
func set_elements():
	# Using the position of the handle as a base for the position of the rest of the drawer.
	var handle_pos = $PadHandle.position
	
	# Animation of the drawer pieces.
	var frame = ($Start.position.y - handle_pos.y) / ($Start.position.y - $End.position.y) * 24
	$Corner1.frame = frame
	$Corner2.frame = frame
	$EndTile.frame = frame
	
	var frame_insert_1 = ($Start.position.y - (handle_pos.y - insert_pos_1)) / ($Start.position.y - $End.position.y) * 24
	$Insert1.frame = frame_insert_1
	$Insert2.frame = frame_insert_1
	$InsertTile.frame = frame_insert_1
	
	# Position of the drawer pieces.
	var drawer_pos = floor(handle_pos.y + 6 - frame / 2.6)
	$Corner1.position.y = drawer_pos
	$Corner2.position.y = drawer_pos
	$Insert1.position.y = drawer_pos - insert_pos_1
	$Insert2.position.y = drawer_pos - insert_pos_1
	$EndTile.position.y = drawer_pos
	$InsertTile.position.y = drawer_pos - insert_pos_1
	$InteriorTile.position.y = drawer_pos + 18
	$Pad.position.y = drawer_pos + 128
	
	# When the drawer passes the middle of the screen,
	#	the handle gets behind or in front of the other drawer pieces.
	if handle_pos.y <= ($Start.position.y - $End.position.y) / 2 + $End.position.y:
		if $PadHandle.get_index() != 0:
			move_child($PadHandle, 0)
	else:
		if $PadHandle.get_index() != 10:
			move_child($PadHandle, 10)

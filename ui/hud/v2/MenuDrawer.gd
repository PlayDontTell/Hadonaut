extends Node2D


var insert_pos_1: int = -291

# warning-ignore:unused_argument
func set_elements():
	# Using the position of the handle as a base for the position of the rest of the drawer.
	var handle_pos = $MenuHandle.position
	
	# Animation of the drawer pieces.
	var frame = ($Start.position.x - handle_pos.x) / ($Start.position.x - $End.position.x) * 24
	$Corner1.frame = frame
	$Corner2.frame = frame
	$EndTile.frame = frame
	
	var frame_insert_1 = ($Start.position.x - (handle_pos.x - insert_pos_1)) / ($Start.position.x - $End.position.x) * 24
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
	
	# When the drawer passes the middle of the screen,
	#	the handle gets behind or in front of the other drawer pieces.
	if handle_pos.x <= ($Start.position.x - $End.position.x) / 2 + $End.position.x:
		if $MenuHandle.get_index() != 0:
			move_child($MenuHandle, 0)
	else:
		if $MenuHandle.get_index() != 10:
			move_child($MenuHandle, 10)

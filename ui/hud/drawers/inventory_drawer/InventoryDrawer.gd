extends Node2D


onready var fade = get_node("../../Fade")

var insert_pos_1: int = 37
var insert_pos_2: int = 250
var last_ratio: float
var ratio_margin : float = 0.05
var ratio: float = 0.0
var shade_intensity: float = 1.0


func _ready():
	set_elements()


# warning-ignore:unused_argument
func set_elements():
	# Using the position of the handle as a base for the position of the rest of the drawer.
	var handle_pos = $InventoryHandle.position
	
	if not $InventoryHandle.blocked_by_pad_drawer:
		var start_to_end = abs($Start.position.y - $End.position.y)
		
		if handle_pos.y <= $Start.position.y - start_to_end * ratio_margin:
			ratio = stepify(abs(($Start.position.y - start_to_end * ratio_margin - handle_pos.y) / 
				(start_to_end * (1 - ratio_margin))), 0.01)
		
		if ratio != last_ratio:
			fade.modulate = Color(1, 1, 1, ratio * shade_intensity)
			last_ratio = ratio
	
	# Animation of the drawer pieces.
	var frame = ($Start.position.y - handle_pos.y) / ($Start.position.y - $End.position.y) * 12
	$Corner1.frame = frame
	$Corner2.frame = frame
	$EndTile.frame = frame
	
	var frame_insert_1 = ($Start.position.y - (handle_pos.y - insert_pos_1)) / ($Start.position.y - $End.position.y) * 24
	$Insert1.frame = frame_insert_1
	$Insert2.frame = frame_insert_1
	$InsertTile.frame = frame_insert_1
	
	var frame_insert_2 = ($Start.position.y - (handle_pos.y - insert_pos_2)) / ($Start.position.y - $End.position.y) * 24
	$Insert3.frame = frame_insert_2
	$Insert4.frame = frame_insert_2
	$InsertTile2.frame = frame_insert_2
	
	# Position of the drawer pieces.
	var drawer_pos = floor(handle_pos.y + 4 - frame / 2.6)
	$Corner1.position.y = drawer_pos
	$Corner2.position.y = drawer_pos
	$Insert1.position.y = drawer_pos + insert_pos_1
	$Insert2.position.y = drawer_pos + insert_pos_1
	$Insert3.position.y = drawer_pos + insert_pos_2
	$Insert4.position.y = drawer_pos + insert_pos_2
	$EndTile.position.y = drawer_pos
	$InsertTile.position.y = drawer_pos + insert_pos_1
	$InsertTile2.position.y = drawer_pos + insert_pos_2
	$InteriorTile.position.y = drawer_pos + 18
	$InteriorTile2.position.y = drawer_pos + 18
	if handle_pos.y < 270:
		$Inventory.position.y = drawer_pos + 16 + frame / 10
	else:
		$Inventory.position.y = 270
	
	# When the drawer passes the middle of the screen,
	#	the handle gets behind or in front of the other drawer pieces.
	if handle_pos.y <= ($End.position.y - $Start.position.y) / 2 + $Start.position.y:
		if $InventoryHandle.get_index() != 0:
			move_child($InventoryHandle, 0)
	else:
		if $InventoryHandle.get_index() != 16:
			move_child($InventoryHandle, 16)

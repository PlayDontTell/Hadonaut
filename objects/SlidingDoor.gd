extends Area2D


export var to_room: String
export var to_x: int
export var to_y: int
export var flip_h: bool
export var door_id: int
var is_opened: bool = false
var is_commanded: bool = false
var is_active: bool = false

onready var current_room = get_node("..")


func _on_Passage_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.pressed:
		var position_ordered = $PointToRoom.position + position
		var action = get_node("../Char").execute_action(to_room, position_ordered, flip_h, "idle")
		yield(action, "completed")
		if get_node("../Char").action == to_room + "_completed":
			get_node("../..").go_to_room(to_room, flip_h, to_x, to_y)


func command():
	var state_command = is_commanded
	if not state_command:
		is_commanded = true
		if is_active:
			$DoorOperatingSound.play()
# warning-ignore:standalone_ternary
			close_door() if is_opened else open_door()
		else:
			yield(get_tree().create_timer(0.2), "timeout")
			$DoorErrorSound.play()
			is_commanded = false


func close_door():
	$CollisionPolygon2D.disabled = true
	yield(get_tree().create_timer(0.2), "timeout")
	$Tween.interpolate_property($Sprite, "offset", $Sprite.offset, Vector2(0, 0), 1,
	Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	$Tween.start()
	yield(get_tree().create_timer(1), "timeout")
	current_room.current_chapter.had_doors[door_id][1] = false
	is_opened = not is_opened
	is_commanded = false


func open_door():
	yield(get_tree().create_timer(0.2), "timeout")
	$Tween.interpolate_property($Sprite, "offset", $Sprite.offset, 
	Vector2(0, -1 * $Sprite.texture.get_size()[1]), 1,
	Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	$Tween.start()
	yield(get_tree().create_timer(0.5), "timeout")
	$CollisionPolygon2D.disabled = false
	yield(get_tree().create_timer(0.5), "timeout")
	current_room.current_chapter.had_doors[door_id][1] = true
	is_opened = not is_opened
	is_commanded = false


func initialize():
	is_active = current_room.current_chapter.had_doors[door_id][0]
	is_opened = current_room.current_chapter.had_doors[door_id][1]
	$CollisionPolygon2D.disabled = not is_opened
	$Sprite.offset = Vector2(0, -1 * $Sprite.texture.get_size()[1]) if is_opened else Vector2(0, 0)

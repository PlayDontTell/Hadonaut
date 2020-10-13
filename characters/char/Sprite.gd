extends Sprite


signal arrived_at_destination

var speed: int = 35
var path: PoolVector2Array


func _process(delta):
	# Calculate the movement distance for this frame.
	var distance_to_walk = speed * delta
	# Move the player along the path until he has run out of movement or the path ends.
	while distance_to_walk > 0 and path.size() > 0:
		var distance_to_next_point = position.distance_to(path[0])
		if distance_to_walk <= distance_to_next_point:
			# The player does not have enough movement left to get to the next point.
			position += position.direction_to(path[0]) * distance_to_walk
			# Orientation of Char
			set_flip_h(position.direction_to(path[0])[0] < 0)
		else:
			# The player get to the next point
			position = path[0]
			path.remove(0)
		# Update the distance to walk
		distance_to_walk -= distance_to_next_point
	# If no more steps, Char is arrived.
	if path.size() == 0:
		Global.last_flip_h = flip_h
# warning-ignore:narrowing_conversion
		Global.last_x = position.x
# warning-ignore:narrowing_conversion
		Global.last_y = position.y
		emit_signal("arrived_at_destination")
		
		
	if flip_h:
		$Head.offset = Vector2(1, 0)
		$Eyes.offset = Vector2(0, 0)
	else:
		$Head.offset = Vector2(0, 0)
		$Eyes.offset = Vector2(-1, 0)
	
	# Direction of the eyes.
	var eyes_global_position = Vector2(0, -36) + position
	var eyes_orientation = eyes_global_position.direction_to(get_viewport().get_mouse_position())
	var eyes_inverted = get_viewport().get_mouse_position() <= eyes_global_position
	# Position of the eyes.
	$Eyes.flip_h = eyes_inverted
	$Head.flip_h = eyes_inverted
	$Eyes.position.y = -36 + eyes_orientation.y


func go_to(path_to_target, target_speed):
	path = path_to_target
	speed = target_speed
	# Animation of Char wlaking and running.
	if path.size() != 0 and speed == 35:
		get_node("../CharAnimation").play("walk_" + CharState.dress_code)
	elif path.size() != 0 and speed == 80:
		get_node("../CharAnimation").play("run_" + CharState.dress_code)

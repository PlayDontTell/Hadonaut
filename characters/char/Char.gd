extends Node2D


var action: String
var running_distance: float = 90


func _ready():
	initialize()
	$Line2D.visible = false


func _unhandled_input(event):
	# Ordering Char to go to a target on the ground.
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed and event.position:
			
			reach(event.position)
			yield($Sprite, "arrived_at_destination")
			initialize()
	
	if event is InputEventMouseMotion:
		if $Navigation2D.get_closest_point(event.position) == event.position:
			Global.mouse_hovering_ground = true
		else:
			Global.mouse_hovering_ground = false


# Function to reset Char's activity (idle).
func initialize():
	action = ""
	$CharAnimation.play("idle_" + CharState.dress_code)


func pick(pushable_name, position_ordered, flip_h):
	var order = execute_action(pushable_name, position_ordered, flip_h, "pick")
	yield(order, "completed")


func push(pushable_name, position_ordered, flip_h):
	var order = execute_action(pushable_name, position_ordered, flip_h, "push")
	yield(order, "completed")


func execute_action(action_name, position_ordered, flip_h, action_type):
		# Focus on the new action.
		action = action_name
		# First go to the target's position.
		reach(position_ordered, action_name)
		yield($Sprite, "arrived_at_destination")
		# When arrived at target, play the push animation.
		if $Sprite.position == position_ordered:
			$CharAnimation.play(action_type + "_" + CharState.dress_code)
			# Orientation of Char
			$Sprite.set_flip_h(flip_h)
			# End of the function (effects of action, according to its type).
			if action_type == "push":
				yield(get_tree().create_timer(0.3), "timeout")
				action = action_name + "_completed"
			elif action_type == "pick":
				yield(get_tree().create_timer(0.6), "timeout")
				action = action_name + "_completed"
			elif action_type == "idle":
				action = action_name + "_completed"
			elif action_type == "stand":
				yield(get_tree().create_timer(0.7), "timeout")
				action = action_name + "_completed"
			print(" ... action completed: " + action_name)

func reach(target_position, action_name = ""):
	if visible:
		# Def  of the current and target positions.
		var current_position = $Sprite.position
		target_position.x = round(target_position.x)
		target_position.y = round(target_position.y)
		# If Char isn't at the target position, find a path.
		if  not current_position == target_position:
			var path_to_target = $Navigation2D.get_simple_path(current_position, target_position)
			# If the target is reachable (no gap between the areas).
			if path_to_target.size() > 0:
				# If the target is reachable (not the closest point).
				if target_position == path_to_target[-1]:
					if action_name == "":
						print("Char going to " + str(target_position) + ".")
					else:
						print("Char going to " + str(target_position) + " to complete action : " + action_name + " ...")
					# Draw the line.
					$Line2D.points = path_to_target
					# Calculation of the total length to go, to assign speed.
					var total_distance: float = 0
					for i in path_to_target.size() - 1:
						total_distance += path_to_target[i].distance_to(path_to_target[i+1])	
					# Assigning speed, according to the running distance minimum.
					var target_speed = 80 if total_distance >= running_distance else 35
					# Sending the information to Sprite.
					$Sprite.go_to(path_to_target, target_speed)

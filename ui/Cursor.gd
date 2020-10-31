extends Sprite


var mouse_pressed: bool = false
var mouse_arrow: bool = false
var mouse_on_ui: bool = false


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	z_index = 64


func _input(event):
	# If the mouse left button is pressed, toggling the mouse_pressed var.
	if event is InputEventMouseButton:
		mouse_pressed = event.pressed
		
	# Placing the cursor on the exact mouse position.
	if event is InputEventMouseMotion:
		position = event.position


# warning-ignore:unused_argument
func _process(delta):
	# Animation of the mouse cursor.
	var special_cursor = ""
	
	if Global.force_hand_cursor:
		special_cursor = "_hand"
		
	if (GlobalInventory.is_using_item and not (not Global.mouse_hovering_inventory
		and GlobalInventory.item_used in ["screwdriver"])) or Global.force_point_cursor:
		special_cursor = "_point"

	if (Global.menu_visible or Global.update_message_visible
		or Global.force_menu_cursor or Global.logo_visible) and not Global.force_point_cursor:
		change_cursor_animation("menu")
	else:
		if mouse_arrow and not mouse_on_ui and not Global.mouse_hovering_count > 0:
			var cursor_direction
			if Global.force_arrow_direction == -1:
				# Measuring angle betwwen the horizontal and the cursor.
				var mouse_pos = get_viewport().get_mouse_position()
				cursor_direction = (Vector2(240, 135).angle_to_point(mouse_pos))
				# Converting the angle to degrees.
				cursor_direction = int(cursor_direction / PI * 180)
				# Converting to a direction (one out of eight).
				cursor_direction = int((cursor_direction + 180 + 22.5) / 45)
			else:
				cursor_direction = Global.force_arrow_direction
			change_cursor_animation("back" + str(cursor_direction))
		else:
			if Global.mouse_hovering_count > 0:
				if mouse_pressed:
					if Global.mouse_hovering_long_action:
						if not Global.long_action_begun:
							change_cursor_animation("long_action")
							Global.long_action_begun = true
					else:
						change_cursor_animation("pressed" + special_cursor)
				else:
					Global.long_action_begun = false
					change_cursor_animation("select" + special_cursor)
			else:
				change_cursor_animation("default" + special_cursor)
				if Global.mouse_hovering_ground:
					change_cursor_animation("ground" + special_cursor)
				if mouse_pressed and (Global.mouse_hovering_ground 
				or Global.mouse_hovering_count > 0):
					change_cursor_animation("pressed" + special_cursor)
	if Global.force_eye_cursor:
		change_cursor_animation("eye")
		
	Global.cursor_animation_frame = $CursorAnimation.get_current_animation_position()


func change_cursor_animation(animation):
	$CursorAnimation.play(animation)
	Global.cursor_animation = animation
	
	
func _on_Area2D_area_entered(area):
	if area.is_in_group("cursor_hover"):
		Global.mouse_hovering_count += 1
	
	elif area.is_in_group("cursor_arrow"):
		mouse_arrow = true
		if area.is_in_group("arrow_N"):
			Global.force_arrow_direction = 6
		elif area.is_in_group("arrow_NE"):
			Global.force_arrow_direction = 7
		elif area.is_in_group("arrow_E"):
			Global.force_arrow_direction = 8
		elif area.is_in_group("arrow_SE"):
			Global.force_arrow_direction = 1
		elif area.is_in_group("arrow_S"):
			Global.force_arrow_direction = 2
		elif area.is_in_group("arrow_SW"):
			Global.force_arrow_direction = 3
		elif area.is_in_group("arrow_W"):
			Global.force_arrow_direction = 4
		elif area.is_in_group("arrow_NW"):
			Global.force_arrow_direction = 5
		else:
			Global.force_arrow_direction = -1
	
	elif area.is_in_group("ui"):
		mouse_on_ui = true
		
	if area.is_in_group("cursor_eye"):
		Global.force_eye_cursor = true
		
	if area.is_in_group("cursor_hand"):
		Global.force_hand_cursor = true
	
	if area.is_in_group("cursor_menu"):
		Global.force_menu_cursor = true


func _on_Area2D_area_exited(area):
	if area.is_in_group("cursor_hover") and Global.mouse_hovering_count > 0:
		Global.mouse_hovering_count -= 1
	elif area.is_in_group("cursor_arrow"):
		mouse_arrow = false
	elif area.is_in_group("ui"):
		mouse_on_ui = false
	
	if area.is_in_group("cursor_eye"):
		Global.force_eye_cursor = false
	
	if area.is_in_group("cursor_hand"):
		Global.force_hand_cursor = false
		
	if area.is_in_group("cursor_menu"):
		Global.force_menu_cursor = false

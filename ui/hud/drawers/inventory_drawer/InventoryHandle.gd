extends RigidBody2D


signal opened()
signal closed


onready var MAX_Y = get_node("../End").position.y
onready var MIN_Y = get_node("../Start").position.y
onready var drawer = get_node("..")

var held: bool = false
var default_modulate: Color
const MAGNET_DISTANCE = 50
const MAGNET_POWER = 0.75
var blocked_by_pad_drawer: bool = false
var drawer_opened: bool = false
var last_y_pos: float
var is_handle_disabled: bool = false


# warning-ignore:unused_argument
func _physics_process(delta):	
	if not sleeping:
		if held and not is_handle_disabled:
			var new_position = get_global_mouse_position().y
			
			if new_position >= MAX_Y and new_position <= MIN_Y:
				if abs(MAX_Y - new_position) <= MAGNET_DISTANCE:
					new_position = lerp(MAX_Y, new_position, 
						pow(abs(MAX_Y - new_position), MAGNET_POWER)/ MAGNET_DISTANCE)
				global_transform.origin = Vector2(-1, new_position)
				
			elif new_position > MIN_Y:
				global_transform.origin = Vector2(-1, MIN_Y)
			elif new_position < MAX_Y:
				global_transform.origin = Vector2(-1, MAX_Y)
		
		if abs(position.y - MIN_Y) <= 1 and drawer_opened:
			if not held:
				emit_signal("closed")
				drawer_opened = false
				
		linear_velocity += Vector2(0, 5 * Global.GRAVITY_FORCE * delta)
		
		if not last_y_pos == int(global_transform.origin.y):
			
			last_y_pos = int(global_transform.origin.y)
			
			drawer.set_elements()
			
			if (last_y_pos == MAX_Y or last_y_pos == MIN_Y) and held:
				$DrawerSounds.play_hit(-10)
		
		if not held and abs(linear_velocity.y) <= 8.5 and abs(last_y_pos - MIN_Y) <= 1:
			set_static(true)


func set_global_transform_origin_y(value):
	value = int(value)
	if value > 35:
		global_transform.origin.y = value
		drawer.set_elements()
	elif value == 35 and not global_transform.origin.y == 35:
		stick(Vector2(-1, 35))


# warning-ignore:unused_argument
func stick(position_to_stick_to):
	if not is_handle_disabled:
		position = position_to_stick_to
		drop()
		set_static(true)
		print("here?")
		$DrawerSounds.play_sticked()
		set_opened()
			


func pickup():
	if held:
		return
	held = true
	set_static(false)


func drop():
	if held:
		mode = RigidBody2D.MODE_CHARACTER
		linear_velocity = Vector2.ZERO
		held = false


func _on_HandleSprite_mouse_entered():
	Global.mouse_hovering_count += 1
	Global.force_hand_cursor = true


func _on_HandleSprite_mouse_exited():
	if Global.mouse_hovering_count > 0:
		Global.mouse_hovering_count -= 1
	Global.force_hand_cursor = false


func _on_HandleSprite_button_down():
	sleeping = false
	pickup()


func _on_HandleSprite_button_up():
	var mouse_pos = get_global_mouse_position().y + 13
	if (abs(MAX_Y - (mouse_pos)) <= MAGNET_DISTANCE or mouse_pos < MAX_Y) and not blocked_by_pad_drawer:
		stick(Vector2(position.x, MAX_Y))
	drop()


func set_opened():
	emit_signal("opened")
	drawer_opened = true


func _on_InventoryHandle_body_entered(body):
	$DrawerSounds.play_hit(abs(linear_velocity.y) * 0.3 - 30)


func set_static(sleeping_state):
	mode = RigidBody2D.MODE_STATIC
	sleeping = sleeping_state
	linear_velocity = Vector2.ZERO
	drawer.set_elements()


func set_to_position_ratio(ratio):
	var last_max_y = 0.0
	if is_handle_disabled:
		set_static(true)
		if ratio <= 0.05:
			global_transform.origin.y = last_max_y
		else:
			global_transform.origin.y = int(ratio * (MIN_Y - last_max_y)) + last_max_y
		drawer.set_elements()

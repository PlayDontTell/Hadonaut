extends RigidBody2D


signal opened
signal closed


onready var MAX_Y = get_node("../Start").position.y
onready var MIN_Y = get_node("../End").position.y
onready var drawer = get_node("..")

var held: bool = false
var default_modulate: Color
var connected: bool = false
const MAGNET_DISTANCE = 50
const MAGNET_POWER = 0.75
var drawer_opened: bool = false
var sticked_opened: bool = false
var blocked_by_inventory_drawer: bool = false
var last_y_pos: float
var is_handle_disabled: bool = false


# warning-ignore:unused_argument
func _physics_process(delta):
	if not sleeping:
		if held and not is_handle_disabled:
			var new_position = get_global_mouse_position().y - 2
			
			if new_position <= MAX_Y and new_position >= MIN_Y:
				if abs(MIN_Y - new_position) <= MAGNET_DISTANCE:
					new_position = lerp(MIN_Y, new_position, 
						pow(abs(MIN_Y - new_position), MAGNET_POWER)/ MAGNET_DISTANCE)
				global_transform.origin = Vector2(0, new_position)
				
			elif new_position < MIN_Y:
				global_transform.origin = Vector2(0, MIN_Y)
				
			elif new_position > MAX_Y:
				global_transform.origin = Vector2(0, MAX_Y)
				
		
		if abs(global_transform.origin.y - MAX_Y) <= 2 and drawer_opened:
			if not held:
				emit_signal("closed")
				drawer_opened = false
		
		linear_velocity += Vector2(0, 5 * Global.GRAVITY_FORCE * delta)
		
		if not last_y_pos == int(global_transform.origin.y):
			drawer.set_elements()
			
			last_y_pos = int(global_transform.origin.y)
			
			if (last_y_pos == MIN_Y or last_y_pos == MAX_Y) and held:
				$DrawerSounds.play_hit(-10)
		
		if not held and abs(linear_velocity.y) <= 8.5 and last_y_pos == MAX_Y:
			set_static(true)


# warning-ignore:unused_argument
func stick(position_to_stick_to):
	if not is_handle_disabled:
		$DrawerSounds.play_sticked()
		global_transform.origin = position_to_stick_to
		drop()
		set_static(true)
		
		if position_to_stick_to.y == 8:
			sticked_opened = true
			emit_signal("opened")
			drawer_opened = true


func pickup():
	if held:
		return
	set_static(false)
	connected = false
	held = true


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
	sticked_opened = false
	pickup()


func _on_HandleSprite_button_up():
	var mouse_pos = get_global_mouse_position().y - 6
	if (abs(MIN_Y - mouse_pos) <= MAGNET_DISTANCE or mouse_pos < MIN_Y) and not blocked_by_inventory_drawer:
		stick(Vector2(position.x, 8))
		
	drop()


func _on_PadHandle_body_entered(body):
	$DrawerSounds.play_hit(abs(linear_velocity.y) * 0.3 - 30)


func set_static(sleeping_state):
	mode = RigidBody2D.MODE_STATIC
	sleeping = sleeping_state
	linear_velocity = Vector2.ZERO
	drawer.set_elements()


func set_to_position_ratio(ratio):
	if sticked_opened and is_handle_disabled:
		set_static(true)
		if ratio <= 0.05:
			global_transform.origin.y = MIN_Y
		else:
			global_transform.origin.y = int(ratio * (MAX_Y - MIN_Y)) + MIN_Y
		drawer.set_elements()

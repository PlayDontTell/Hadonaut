extends RigidBody2D


signal opened(position)
signal closed


onready var MAX_X = get_node("../End").position.x
onready var MIN_X = get_node("../Start").position.x
onready var drawer = get_node("..")

var held: bool = false
var default_modulate: Color
var connected: bool = false
const MAGNET_DISTANCE = 30
const MAGNET_POWER = 0.75
var notches_list: Array = [60, 430]
var blocked_by_pad_drawer: bool = false
var drawer_opened: bool = false
var sticked_opened: int = 0
var last_x_pos: float
var is_handle_disabled: bool = false


# warning-ignore:unused_argument
func _physics_process(delta):	
	if not sleeping:
		if held and not is_handle_disabled:
			var new_position = get_global_mouse_position().x + 13
			
			if new_position <= MAX_X and new_position >= MIN_X:
				for i in notches_list:
					if abs(i - new_position) <= MAGNET_DISTANCE:
						new_position = lerp(i, new_position, 
							pow(abs(i - new_position), MAGNET_POWER)/ MAGNET_DISTANCE)
				global_transform.origin = Vector2(new_position, -103)
				
			elif new_position < MIN_X:
				global_transform.origin = Vector2(MIN_X, -103)
			elif new_position > MAX_X:
				global_transform.origin = Vector2(MAX_X, -103)
		
		if abs(position.x - 26) <= 1 and drawer_opened:
			if not held:
				emit_signal("closed")
				drawer_opened = false
				
		linear_velocity += Vector2(-5 * Global.GRAVITY_FORCE * delta, 0)
		
		if not last_x_pos == int(global_transform.origin.x):
			drawer.set_elements()
			
			last_x_pos = int(global_transform.origin.x)
			
			if (last_x_pos == MAX_X or last_x_pos == MIN_X) and held:
				$DrawerSounds.play_hit(-10)
		
		if not held and abs(linear_velocity.x) <= 8.5 and last_x_pos in [MIN_X, 60, 430]:
			set_static(true)


# warning-ignore:unused_argument
func stick(position_to_stick_to):
	if not is_handle_disabled:
		$DrawerSounds.play_sticked()
		position = position_to_stick_to
		drop()
		set_static(true)
		
		if position_to_stick_to.x == 60:
			sticked_opened = 1
			set_opened("item_bar")
		elif position_to_stick_to.x == 430:
			sticked_opened = 2
			set_opened("full")
			


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
	sticked_opened = 0
	pickup()


func _on_HandleSprite_button_up():
	var mouse_pos = get_global_mouse_position().x + 13
	if abs(430 - (mouse_pos)) <= MAGNET_DISTANCE or (mouse_pos > 430 and not blocked_by_pad_drawer):
		stick(Vector2(430, position.y))
	if abs(60 - (mouse_pos)) <= MAGNET_DISTANCE or (mouse_pos > 60 and blocked_by_pad_drawer):
		stick(Vector2(60, position.y))
	drop()


func set_opened(arg):
	emit_signal("opened", arg)
	drawer_opened = true


func _on_InventoryHandle_body_entered(body):
	$DrawerSounds.play_hit(abs(linear_velocity.x) * 0.3 - 30)


func set_static(sleeping_state):
	mode = RigidBody2D.MODE_STATIC
	sleeping = sleeping_state
	linear_velocity = Vector2.ZERO
	drawer.set_elements()


func set_to_position_ratio(ratio):
	var last_max_x = 0.0
	if not sticked_opened == 0 and is_handle_disabled:
		if sticked_opened == 1:
			last_max_x = 60
		else:
			last_max_x = 430
		set_static(true)
		if ratio <= 0.05:
			global_transform.origin.x = last_max_x
		else:
			global_transform.origin.x = int(ratio * (MIN_X - last_max_x)) + last_max_x
		drawer.set_elements()

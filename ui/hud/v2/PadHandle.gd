extends RigidBody2D


signal opened
signal closed


onready var MAX_Y = get_node("../Start").position.y + 9
onready var MIN_Y = get_node("../End").position.y - 18
onready var drawer = get_node("..")

var held: bool = false
var default_modulate: Color
var connected: bool = false
const MAGNET_DISTANCE = 50
const MAGNET_POWER = 0.75
var drawer_opened: bool = false
var blocked_by_inventory_drawer: bool = false
var last_y_pos: float


# warning-ignore:unused_argument
func _physics_process(delta):
	if held:
		var new_position = get_global_mouse_position().y - 2
		
		if new_position <= MAX_Y and new_position >= MIN_Y:
			if abs(8 - new_position) <= MAGNET_DISTANCE:
				new_position = lerp(8, new_position, 
					pow(abs(8 - new_position), MAGNET_POWER)/ MAGNET_DISTANCE)
			global_transform.origin = Vector2(0, new_position)
			
		elif new_position < MIN_Y:
			global_transform.origin = Vector2(0, MIN_Y)
			
		elif new_position > MAX_Y:
			global_transform.origin = Vector2(0, MAX_Y)
			
	
	if abs(position.y - 241) <= 2 and drawer_opened:
		if not held:
			emit_signal("closed")
			drawer_opened = false
	
	linear_velocity += Vector2(0, 5 * Global.GRAVITY_FORCE * delta)
	
	if not last_y_pos == int(position.y):
		drawer.set_elements()
		
		var mouse_speed = Input.get_last_mouse_speed().y
		if (int(position.y) == MIN_Y or (int(position.y) == MAX_Y and mouse_speed < 0)) and held:
			$DrawerSounds.play_hit(abs(mouse_speed) * 0.1 - 30)
		
		last_y_pos = int(position.y)

# warning-ignore:unused_argument
func stick(position_to_stick_to):
	$DrawerSounds.play_sticked()
	global_transform.origin = position_to_stick_to
	drop()
	mode = RigidBody2D.MODE_STATIC


func pickup():
	if held:
		return
	mode = RigidBody2D.MODE_STATIC
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
	pickup()


func _on_HandleSprite_button_up():
	var mouse_pos = get_global_mouse_position().y - 6
	if (abs(8 - mouse_pos) <= MAGNET_DISTANCE or mouse_pos <= 7) and not blocked_by_inventory_drawer:
		stick(Vector2(position.x, 8))
		emit_signal("opened")
		drawer_opened = true
	drop()


func _on_PadHandle_body_entered(body):
	$DrawerSounds.play_hit(abs(linear_velocity.y) * 0.3 - 30)

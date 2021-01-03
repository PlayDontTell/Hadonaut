extends RigidBody2D


signal opened
signal closed


onready var MAX_X = get_node("../Start").position.x
onready var MIN_X = get_node("../End").position.x
onready var drawer = get_node("..")

var held: bool = false
var default_modulate: Color
var connected: bool = false
const MAGNET_DISTANCE = 30
const MAGNET_POWER = 0.75
var notches_list: Array = [96]
var drawer_opened: bool = false
var last_x_pos: float


# warning-ignore:unused_argument
func _physics_process(delta):	
	if not sleeping:
		if held:
			var new_position = get_global_mouse_position().x + 9
			
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
		
		if abs(global_transform.origin.x - 468) <= 2 and drawer_opened:
			if not held:
				emit_signal("closed")
				drawer_opened = false
		
		linear_velocity += Vector2(5 * Global.GRAVITY_FORCE * delta, 0)
		
		if not last_x_pos == int(global_transform.origin.x):
			drawer.set_elements()
			
			last_x_pos = int(global_transform.origin.x)
			
			if (last_x_pos== MIN_X or last_x_pos == MAX_X) and held:
				$DrawerSounds.play_hit(-10)
		
		if not held and abs(linear_velocity.x) <= 8.5 and last_x_pos == MAX_X:
			set_static(true)


# warning-ignore:unused_argument
func stick(position_to_stick_to):
	$DrawerSounds.play_sticked()
	position = position_to_stick_to
	drop()
	set_static(true)


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
	pickup()


func _on_HandleSprite_button_up():
	var mouse_pos = get_global_mouse_position().x - 6
	if abs(96 - mouse_pos) <= MAGNET_DISTANCE or mouse_pos <= 96:
		stick(Vector2(96, position.y))
		emit_signal("opened")
		drawer_opened = true
	drop()


func _on_MenuHandle_body_entered(body):
	$DrawerSounds.play_hit(abs(linear_velocity.x) * 0.3 - 30)


func set_static(sleeping_state):
	mode = RigidBody2D.MODE_STATIC
	sleeping = sleeping_state
	drawer.set_elements()

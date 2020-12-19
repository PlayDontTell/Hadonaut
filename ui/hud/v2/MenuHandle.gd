extends RigidBody2D


onready var MAX_X = get_node("../Start").position.x + 18
onready var MIN_X = get_node("../End").position.x
onready var drawer = get_node("..")

var held: bool = false
var default_modulate: Color
var connected: bool = false
const MAGNET_DISTANCE = 50
const MAGNET_POWER = 0.75
var notches_list: Array = [96]
var last_x_pos: float


# warning-ignore:unused_argument
func _physics_process(delta):	
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
	
	linear_velocity += Vector2(5 * Global.GRAVITY_FORCE * delta, 0)
	
	if not last_x_pos == int(position.x):
		drawer.set_elements()
		
		var mouse_speed = Input.get_last_mouse_speed().x
		if (int(position.x) == MIN_X or (int(position.x) == MAX_X)) and held:
			$DrawerSounds.play_hit(abs(mouse_speed) * 0.1 - 30)
	
		last_x_pos = int(position.x)


# warning-ignore:unused_argument
func stick(position_to_stick_to):
	$DrawerSounds.play_sticked()
	position = position_to_stick_to
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
	var mouse_pos = get_global_mouse_position().x - 6
	if abs(96 - mouse_pos) <= MAGNET_DISTANCE or mouse_pos <= 96:
		stick(Vector2(96, position.y))
	drop()


func _on_MenuHandle_body_entered(body):
	$DrawerSounds.play_hit(abs(linear_velocity.x) * 0.3 - 30)

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
var last_x_pos: float


# warning-ignore:unused_argument
func _physics_process(delta):	
	if held:
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
	
	if not last_x_pos == int(position.x):
		drawer.set_elements()
		last_x_pos = int(position.x)
		var mouse_speed = Input.get_last_mouse_speed().x
		if (int(position.x) == MAX_X or (int(position.x) == MIN_X and mouse_speed < 0)) and held:
			$DrawerSounds.play_hit(abs(Input.get_last_mouse_speed().x) * 0.3 - 30)


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
	var mouse_pos = get_global_mouse_position().x + 13
	if abs(430 - (mouse_pos)) <= MAGNET_DISTANCE or (mouse_pos > 430 and not blocked_by_pad_drawer):
		stick(Vector2(430, position.y))
		set_opened("full")
	if abs(60 - (mouse_pos)) <= MAGNET_DISTANCE or (mouse_pos > 60 and blocked_by_pad_drawer):
		stick(Vector2(60, position.y))
		set_opened("item_bar")
	drop()


func set_opened(arg):
	emit_signal("opened", arg)
	drawer_opened = true


func _on_InventoryHandle_body_entered(body):
	$DrawerSounds.play_hit(abs(linear_velocity.x) * 0.3 - 30)

extends RigidBody2D


onready var current_chapter = get_node("../../../..")

var held = false
var default_modulate: Color
var engine_started: bool = true
var connected: bool = false

# warning-ignore:unused_argument
# warning-ignore:unused_argument
func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			pickup()


func _unhandled_input(event):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT:
		if not event.pressed:
			drop(Input.get_last_mouse_speed())


# warning-ignore:unused_argument
func _physics_process(delta):
	if held:
		global_transform.origin = get_global_mouse_position()
	
	var lever_pin_pos = (get_node("../../LeverBack2/LeverPinHook").position 
		- get_node("..").position + get_node("../../LeverBack2").position)
	var pin_connection_pos = (get_node("../PinConnectionHook").position)
	
	if position.distance_to(lever_pin_pos) <= 5 and not held:
		stick(lever_pin_pos, "lever_pin")
		if current_chapter.maintenance_lever:
			if not engine_started:
				engine_started = true
				if not connected:
					connected = true
					$ConnectionSound.play()
				yield(get_tree().create_timer(0.5), "timeout")
				current_chapter.get_node("ChapterRes/Atmo/EngineStart").play()
		else:
			current_chapter.set_ship_power("night")
			current_chapter.get_node("ChapterRes/Atmo/EngineStart").stop()
			engine_started = false
		
		
	if position.distance_to(pin_connection_pos) <= 5 and not held:
		stick(pin_connection_pos, "pin_connection")
		if not connected:
			connected = true
			$ConnectionSound.play()
		if current_chapter.maintenance_lever:
			current_chapter.set_ship_power("day")
			Global.add_to_playthrough_progress("You connected the ship to the reactor.")
			if not engine_started:
				engine_started = true
				current_chapter.had_doors[0][0] = true
				yield(get_tree().create_timer(0.5), "timeout")
				current_chapter.get_node("ChapterRes/Atmo/EngineStart").play()


func stick(position_to_stick_to, position_name):
	position = position_to_stick_to
	current_chapter.red_cable_stuck_to = position_name
	drop()
	mode = RigidBody2D.MODE_STATIC


func pickup():
	if held:
		return
	mode = RigidBody2D.MODE_STATIC
	if current_chapter.red_cable_stuck_to == "pin_connection":
		current_chapter.red_cable_stuck_to = ""
		$DeconnectionSound.play()
	connected = false
	current_chapter.set_ship_power("night")
	current_chapter.get_node("ChapterRes/Atmo/EngineStart").stop()
	engine_started = false
	held = true


# warning-ignore:unused_argument
func drop(impulse=Vector2.ZERO):
	if held:
		mode = RigidBody2D.MODE_CHARACTER
		held = false


func _on_StaticBody2D_mouse_entered():
	drop()


func _on_RigidBody2D_mouse_entered():
	Global.mouse_hovering_count += 1
	default_modulate = $Sprite.modulate
	$Sprite.modulate = Global.highlight_tint


func _on_RigidBody2D_mouse_exited():
	if Global.mouse_hovering_count > 0:
		Global.mouse_hovering_count -= 1
		$Sprite.modulate = default_modulate

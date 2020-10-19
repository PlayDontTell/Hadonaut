extends WorldEnvironment


# Game start conditions
export var ship_power: String = "night"
export var starting_room: String = "leverbuffet" if Global.DEV_MODE else "cryopod"

# The instanced room the player is playing in (node).
var current_room = null
# The instanced UI node.
var ui = null

# CHAPTER GLOBAL VARIABLES
var chapter_has_begun: bool = Global.DEV_MODE
# Doors' state's list :
var had_doors = [
#   [is active, is open]
	[false, false], #0 flora | cryopod
	[false, true], #1 cryopod | safebay_top
	[false, false], #2 science | safebay_bottom
	[false, false], #3 safebay_right | control
	[false, false], #4 safebay_top
	[false, false], #5 safebay_bottom
	[false, false], #6 safebay_right
	[false, false], #7 reactor | maintenance
]
# ROOMS GLOBAL VARIABLES
# Cryopod global variables :
var closet_door_closed: bool = true
var cloths_taken: bool = false
var trap_keys_taken: bool = false
var trap_is_closed: bool = true
var cryopod_door_closed: bool = false
# Maintenance global variables :
var screwdriver_taken: bool = false
# Flora global variables :
var pad_taken: bool = false


func _init():
	Global.chapter_name = "01_hadoscaphe"
	
	
func _ready():
	
	$ChapterRes/Atmo/SpaceHum.play()
	if not Global.DEV_MODE:
		
		var message = $UI/UpdateMessageScreen.display_version_message()
		if message is GDScriptFunctionState: # Still working.
			message = yield(message, "completed")
			
		$ChapterRes/Music/AirPrelude.play()

	go_to_room(starting_room, false, 253, 131)
	
#	else:
#		for item in GlobalInventory.existing_items:
#			$UI/Inventory.add(item)
	
	if Global.DEV_MODE:
		for i in range(had_doors.size()):
			had_doors[i][0] = true
			had_doors[i][1] = true
	
	$UI/HUD/PadButton.visible = pad_taken or Global.DEV_MODE


# Function to set the ship power ("day" or "night").
func set_ship_power(setting):
	
	# Brightness saturation effect if the room is lit.
	if setting == "day" and not setting == ship_power:
		# interpolating the brightness of the viewport.
		var tween = current_room.get_node("Tween")
		tween.interpolate_property(current_room, "modulate", Color(1.4, 1.4, 1.4),
		Color(1, 1, 1), 3, Tween.TRANS_SINE, Tween.EASE_OUT)
		tween.start()
	
	# All the operations triggered by the change of the ship_power var are done,
	# the new value can be stored in the ship_poer var.
	ship_power = setting
	
	# Initializinf all the light effects specified in the current room script.
	current_room.initialize_light()

	# Change the animation of the set ("day" or "night").
	if current_room.has_node("Set/AnimationPlayer"):
		current_room.get_node("Set/AnimationPlayer").play(ship_power)
	
	# If the room contains Char, modulating its appearance.
	if current_room.has_node("Char/Sprite"):
		if ship_power == "day":
			current_room.get_node("Char/Sprite").modulate = Color(1,1,1)
		else:
			current_room.get_node("Char/Sprite").modulate = Color(0.5,0.5,0.7)


# Function to order the change of the room.
func go_to_room(name, flip_h = Global.last_flip_h, to_x = Global.last_x, to_y = Global.last_y):
	Global.last_flip_h = flip_h
	Global.last_x = to_x
	Global.last_y = to_y
	
	# If an instance of the UI node is child of the chapter node,
	# it plays a fade out effect (fade to black).
	if has_node("UI/Fade/AnimationPlayer"):
		var fade_node = get_node("UI/Fade/AnimationPlayer")
		fade_node.play("fade_out")
		# Waiting for the fade out to finish, before changing the current room.
		yield(fade_node, "animation_finished")
	
	# Getting the room's node path from the list of the rooms of this chapter.
	var path = ("res://chapters/01_hadoscaphe/locations/" + name + "/" 
		+ name.left(1).to_upper() + name.right(1) + ".tscn")
	
	# Order the deferred change of the room.
	call_deferred("_deferred_go_to_room", path, flip_h, to_x, to_y)


# Function to change the room.
func _deferred_go_to_room(path, flip_h, to_x, to_y):
	# Unload the current room and the instance of the UI node (all the nodes,
	# except for the ChapterRes node.
	if get_child_count() > 0:
		for i in get_children():
			if not i.get_name() == "ChapterRes" and not i.get_name() == "UI":
				remove_child(i)
				i.queue_free()

	# Load the next room and the ui node.
	var next_room = ResourceLoader.load(path)

	# Instance the next room and the ui node.
	current_room = next_room.instance()

	# Make them children of this chapter node, making sure the room node is first.
	add_child(current_room)
	move_child(current_room, 0)
	
	# Reset cursor hovering count.
	Global.mouse_hovering_count = 0
	
	# If the room contains Char, positionning him and orienting him.
	if current_room.has_node("Char/Sprite"):
		current_room.get_node("Char/Sprite").position = Vector2(to_x, to_y)
		current_room.get_node("Char/Sprite").set_flip_h(flip_h)
	
	# The room is loaded.
	print("Going to " + current_room.name)
	$UI/Fade/AnimationPlayer.play("fade_in")

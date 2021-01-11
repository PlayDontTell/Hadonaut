extends WorldEnvironment


# The instanced room the player is playing in (node).
onready var current_room = null
# The instanced UI node.
onready var hud = $HUD
onready var fade_player = $HUD/Fade/FadePlayer


# Game start conditions
export var ship_power: String = "night"
export var starting_room: String = "flora_desk" if Global.DEV_MODE else "cryopod"

# CHAPTER GLOBAL VARIABLES
var chapter_has_begun: bool = Global.DEV_MODE
# Doors' state's list :
var had_doors: Array = [
#   [is active, is open]
	[false, false], #0 flora | cryopod
	[false, true], #1 cryopod | safebay_top
	[false, false], #2 science | safebay_bottom
	[false, false], #3 safebay_right | control
	[false, false], #4 safebay_top
	[false, false], #5 safebay_bottom
	[false, false], #6 safebay_right
	[true, false], #7 reactor | maintenance
]
# ROOMS GLOBAL VARIABLES
# Cryopod global variables :
var closet_door_closed: bool = true
var cloths_taken: bool = false
var trap_keys_taken: bool = false
var trap_is_closed: bool = true
var cryopod_door_closed: bool = false
var inventory_taken: bool = false

# Maintenance global variables :
var screwdriver_taken: bool = false
var maintenance_lever: bool = false
var buffet_screws: Array = [true, true, true, true, true, true, true, true]
var left_buffet_door: bool = false
var right_buffet_door: bool = false
var right_buffet_door_unscrewed: bool = true
var red_cable_pin_position: Vector2 = Vector2(0, 0)
var red_cable_stuck_to: String = ""

# Flora global variables :
var pad_taken: bool = false
var map_module_taken: bool = false


func _init():
	Global.chapter_name = "01_hadoscaphe"
	set_tints()


func _ready():
	if not chapter_has_begun:
		$HUD.modulate = Global.COLOR_BLACK
		$HUD/Tween.interpolate_property($HUD, "modulate", Global.COLOR_BLACK,
			Global.COLOR_DEFAULT, 2, Tween.TRANS_LINEAR,Tween.EASE_IN_OUT)
	
	$ChapterRes/Atmo/SpaceHum.volume_db = -60
	$HUD/Tween.interpolate_property($ChapterRes/Atmo/SpaceHum, "volume_db",
	-60, -6, 2, Tween.TRANS_LINEAR,Tween.EASE_IN_OUT)
	$HUD/Tween.start()
	
	$ChapterRes/Atmo/SpaceHum.play()
	if not Global.DEV_MODE:
		$ChapterRes/Music/AirPrelude.play()
	
	go_to_room(starting_room, false, 253, 147)
	
#	else:
#		for item in GlobalInventory.existing_items:
#			$UI/Inventory.add(item)
	
	if Global.DEV_MODE:
		for i in range(had_doors.size()):
			had_doors[i][0] = true
			had_doors[i][1] = true


# Function to set the ship power ("day" or "night").
func set_ship_power(setting):
	# Brightness saturation effect if the room is lit.
	if setting == "day" and not setting == ship_power:
		# interpolating the brightness of the viewport.
		var tween = current_room.get_node("Tween")
		tween.interpolate_property(current_room, "modulate", Global.highlight_tint,
		Global.COLOR_DEFAULT, 3, Tween.TRANS_SINE, Tween.EASE_OUT)
		tween.start()
	
	# All the operations triggered by the change of the ship_power var are done,
	# the new value can be stored in the ship_poer var.
	ship_power = setting
	set_tints()
	
	# Initializinf all the light effects specified in the current room script.
	current_room.initialize_light()
	
	# If the room contains Char, modulating its appearance.
	if current_room.has_node("Char/Sprite"):
		if ship_power == "day":
			current_room.get_node("Char/Sprite").modulate = Global.COLOR_DEFAULT
		else:
			current_room.get_node("Char/Sprite").modulate = Global.COLOR_BLUE_TINTED


# Function to order the change of the room.
func go_to_room(name, flip_h = Global.last_flip_h, to_x = Global.last_x, to_y = Global.last_y, action_type = "idle"):
	Global.last_flip_h = flip_h
	Global.last_x = to_x
	Global.last_y = to_y
		
	# If an instance of the UI node is child of the chapter node,
	# it plays a fade out effect (fade to black).
	if chapter_has_begun:
		fade_player.play("fade_out")
		# Waiting for the fade out to finish, before changing the current room.
		yield(fade_player, "animation_finished")
		fade_player.play("fade_in")
	else:
		fade_player.play("long_fade_in")
	
	# Getting the room's node path from the list of the rooms of this chapter.
	var path = ("res://chapters/01_hadoscaphe/locations/" + name + "/" 
		+ name.left(1).to_upper() + name.right(1) + ".tscn")
	
	# Order the deferred change of the room.
	call_deferred("_deferred_go_to_room", path, flip_h, to_x, to_y, action_type)
	
	Global.set_room_name(name)

# Function to change the room.
func _deferred_go_to_room(path, flip_h, to_x, to_y, action_type):
	# Unload the current room and the instance of the UI node (all the nodes,
	# except for the ChapterRes node.
	if get_child_count() > 0:
		for i in get_children():
			if not i.get_name() == "ChapterRes" and not i.get_name() == "HUD":
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
	Global.reset_ui()
	
	# If the room contains Char, positionning him and orienting him.
	if current_room.has_node("Char"):
		current_room.get_node("Char/CharAnimation").play(action_type + "_" + CharState.dress_code)
		current_room.get_node("Char/Sprite").position = Vector2(to_x, to_y)
		current_room.get_node("Char/Sprite").set_flip_h(flip_h)
	
	# The room is loaded.
	print("       [displaying the " + current_room.name + " room]")


func set_tints():
	match ship_power:
		"day":
			Global.lighting_tint = Global.COLOR_DEFAULT
			Global.highlight_tint = Global.COLOR_DAY_HIGHLIGHT
			Global.modulated_highlight_tint = Global.COLOR_DAY_HIGHLIGHT
		"night":
			Global.lighting_tint = Global.COLOR_BLUE_TINTED
			Global.highlight_tint = Global.COLOR_NIGHT_HIGHLIGHT
			Global.modulated_highlight_tint = Global.COLOR_BLUE_TINTED_HIGHLIGHT

extends Node


# Meta variables
const DEV_MODE: bool = true
var count_test: int = 0

# Story variables
var chapter_name: String
var room_name: String
var playthrough_progress: PoolStringArray = []
const AVAILABLE_EVENTS_QUANTITY: int = 18
var all_has_been_seen: bool = false

# Last position of Char
var last_flip_h: bool
var last_x: int
var last_y: int
var last_room_name: String = ""

# UI states
var update_message_visible: bool = false
var logo_visible: bool = false
var pad_drawer_opened: bool = false
var inventory_drawer_opened: bool = false
var menu_visible: bool = false
# Cursor states.
var mouse_hovering_ground: bool = false
var mouse_hovering_count: int = 0
var mouse_hovering_long_action: bool = false
var mouse_hovering_inventory: bool = false
var long_action_begun: bool = false
var force_eye_cursor: bool = false
var force_hand_cursor: bool = false
var force_point_cursor: bool = false
var force_menu_cursor: bool = false
var force_arrow_direction: int = -1
var force_hidden_cursor: bool = false
var cursor_animation: String
var cursor_animation_frame: float

# Colors
const COLOR_DEFAULT = Color(1, 1, 1, 1)
const COLOR_NIGHT_HIGHLIGHT = Color(1.5, 1.5, 1.5, 1)
const COLOR_DAY_HIGHLIGHT = Color(1.3, 1.3, 1.3, 1)
const COLOR_BLUE_TINTED_HIGHLIGHT = Color(0.7, 0.7, 0.9, 1)
const COLOR_BLUE_TINTED = Color(0.5, 0.5, 0.7, 1)
const COLOR_RED_TINTED = Color(0.7, 0.5, 0.5, 1)
const COLOR_TRANPARENT = Color(0, 0, 0, 0)
const COLOR_SHADED = Color(0.7, 0.7, 0.7, 1)
const COLOR_BLACK = Color(0, 0, 0, 1)
const COLOR_WHITE = Color(4, 4, 4, 1)
var lighting_tint: Color
var highlight_tint: Color = COLOR_DAY_HIGHLIGHT
var modulated_highlight_tint: Color

# PHYSICS CONSTANTS AND VARIABLES
const GRAVITY_FORCE = 98


func _ready():
	 OS.window_fullscreen =  not DEV_MODE


func print_test():
	print(count_test)
	count_test += 1


func toggle_pause_on():
	if not get_tree().paused:
		get_tree().paused = true
		Physics2DServer.set_active(true)
		print("__GAME_PAUSED__")


func toggle_pause_off():
	if get_tree().paused:
		get_tree().paused = false
		print("__GAME_RESUMED__")


func reset_ui():
	mouse_hovering_ground = false
	mouse_hovering_count = 0
	mouse_hovering_long_action = false
	mouse_hovering_inventory = false
	long_action_begun = false
	force_eye_cursor = false
	force_hand_cursor = false
	force_point_cursor = false
	force_menu_cursor = false
	force_hidden_cursor = false


func set_room_name(new_name):
	# Saving the name of the last room Char was in.
	if last_room_name == "":
		last_room_name = new_name
	else:
		last_room_name = room_name
		
	room_name = new_name
	add_to_playthrough_progress("You went to the " + new_name + " room.")


func add_to_playthrough_progress(event):
	if not event in playthrough_progress:
		playthrough_progress.append(event)
		print("* new event [" + str(playthrough_progress.size()) 
			+ "/" + str(AVAILABLE_EVENTS_QUANTITY) + "]: " + event)
		have_all_availale_events_been_played()

func have_all_availale_events_been_played():
	# Tests if all the events in the game have been seen.
	if playthrough_progress.size() == AVAILABLE_EVENTS_QUANTITY:
		all_has_been_seen = true
		print("You've seen all the actual content of the game.")


func disable_input(duration):
	# Disable all input and hide the cursor for <duration> seconds.
	get_tree().get_root().set_disable_input(true)
	force_hidden_cursor = true
	yield(get_tree().create_timer(duration), "timeout")
	get_tree().get_root().set_disable_input(false)
	force_hidden_cursor = false

extends Node


# Meta variables
const DEV_MODE: bool = true

# Story variables
var chapter_name: String
var room_name: String

# Last position of Char
var last_flip_h: bool
var last_x: int
var last_y: int

# UI states
var pad_visible: bool = false
var menu_visible: bool = false
var update_message_visible: bool = false
# Cursor states.
var mouse_hovering_ground: bool = false
var mouse_hovering_count: int = 0
var mouse_hovering_long_action: bool = false
var mouse_hovering_inventory: bool = false
var long_action_begun: bool = false
var force_eye_cursor: bool = false
var force_hand_cursor: bool = false
var force_menu_cursor: bool = false
var force_arrow_direction: int = -1
var cursor_animation: String
var cursor_animation_frame: float

# Colors
const COLOR_DEFAULT = Color(1, 1, 1, 1)
var COLOR_HIGHLIGHT = Color(1.8, 1.8, 1.8, 1)
var COLOR_SLIGHT_HIGHLIGHT = Color(1.2, 1.2, 1.2, 1)
var COLOR_BLUE_TINTED = Color(0.5, 0.5, 0.7, 1)
var COLOR_TRANPARENT = Color(0, 0, 0, 0)
var COLOR_SHADED = Color(0.7, 0.7, 0.7, 1)
var COLOR_BLACK = Color(0, 0, 0, 1)


func _ready():
	 OS.window_fullscreen = not DEV_MODE


func toggle_pause_on():
	get_tree().paused = true


func toggle_pause_off():
	get_tree().paused = false

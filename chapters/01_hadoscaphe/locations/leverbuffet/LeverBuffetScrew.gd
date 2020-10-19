extends AnimatedSprite


onready var current_chapter = get_node("../../..")
onready var current_room = get_node("../..")

export var initial_frame: int = 0
export var id: int
var started: bool
var screwed: bool = true


func _ready():
# warning-ignore:standalone_ternary
	set_drawn() if current_chapter.buffet_screws[id] else set_hidden()
	initialize_light(current_chapter.ship_power)


# warning-ignore:unused_argument
func _process(delta):
	if Global.cursor_animation == "long_action" and $LongActionObject.mouse_on_object:
		play()
	else:
		frame = (initial_frame)


func initialize_light(time):
	animation = time
	frame = initial_frame


func hide():
	current_chapter.buffet_screws[id] = false
	set_hidden()
	current_room.refresh_door()


func draw():
	current_chapter.buffet_screws[id] = true
	set_drawn()
	current_room.refresh_door()


func set_hidden():
	visible = false
	$LongActionObject/CollisionShape2D.disabled = true


func set_drawn():
	visible = true
	$LongActionObject/CollisionShape2D.disabled = false


func _on_LongActionObject_ready_for_long_action_effects():
	hide()


func _on_LongActionObject_long_action_stopped():
	started = false
	$AudioStreamPlayer2D.stop()


func _on_LongActionObject_long_action_started():
	if not started:
		started = true
		$AudioStreamPlayer2D.play()

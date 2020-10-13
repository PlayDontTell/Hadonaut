extends Sprite


export var initial_orientation: float = 0
export var door: String
export var screw_id: int
var started: bool = false


func _ready():
	$AnimationPlayer.seek(initial_orientation * 0.05)


func initialize_light(time):
	$AnimationPlayer.play(time)


# warning-ignore:unused_argument
func _process(delta):
	if Global.cursor_animation == "long_action" and $LongActionObject.mouse_on_object:
		$AnimationPlayer.play()
	else:
		$AnimationPlayer.seek(initial_orientation * 0.05)


func _on_LongActionObject_ready_for_long_action_effects():
	get_node("../..").refresh_door(door, screw_id)
	visible = false
	$LongActionObject/CollisionShape2D.disabled = true


func _on_LongActionObject_long_action_stopped():
	started = false
	$AudioStreamPlayer2D.stop()


func _on_LongActionObject_long_action_started():
	if not started:
		started = true
		$AudioStreamPlayer2D.play()

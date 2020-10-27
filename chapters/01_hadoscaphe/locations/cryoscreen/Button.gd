extends Area2D


export var id: int

onready var current_chapter = get_node("../..")


func _ready():
	$AnimationPlayer.play("default_" + current_chapter.ship_power)


# warning-ignore:unused_argument
# warning-ignore:unused_argument
func _on_Button_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.pressed:
			$AnimationPlayer.play("pressed_" + current_chapter.ship_power)
			$ButtonPressed.play()
		else:
			$AnimationPlayer.play("default_" + current_chapter.ship_power)
			$ButtonReleased.play()

func initialize_light():
	$AnimationPlayer.play("default_" + current_chapter.ship_power)

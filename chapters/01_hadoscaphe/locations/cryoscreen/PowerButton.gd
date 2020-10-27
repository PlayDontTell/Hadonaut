extends Area2D


onready var current_chapter = get_node("../..")


func _ready():
	$AnimationPlayer.play("default_" + current_chapter.ship_power)


# warning-ignore:unused_argument
# warning-ignore:unused_argument
func _on_PowerButton_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.pressed:
			$AnimationPlayer.play("pressed_" + current_chapter.ship_power)
			$ButtonPressed.play()
		else:
			$AnimationPlayer.play("default_" + current_chapter.ship_power)
			$ButtonReleased.play()

func initialize_light():
	$AnimationPlayer.play("default_" + current_chapter.ship_power)

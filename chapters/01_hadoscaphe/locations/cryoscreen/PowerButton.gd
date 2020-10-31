extends Area2D


onready var current_chapter = get_node("../..")
var default_modulate: Color


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


func _on_PowerButton_area_entered(area):
	if area.is_in_group("cursor"):
		default_modulate = $Sprite.modulate
		$Sprite.modulate = Global.highlight_tint


func _on_PowerButton_area_exited(area):
	if area.is_in_group("cursor"):
		$Sprite.modulate = default_modulate

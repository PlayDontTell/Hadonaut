extends Control


var has_been_displayed: bool = false


func _ready():
	hide()


func _on_RichTextLabel_meta_clicked(meta):
# warning-ignore:return_value_discarded
	OS.shell_open(meta)


# warning-ignore:unused_argument
func _on_RichTextLabel_meta_hover_started(meta):
	Global.force_point_cursor = true
	Global.mouse_hovering_count += 1


# warning-ignore:unused_argument
func _on_RichTextLabel_meta_hover_ended(meta):
	Global.force_point_cursor = false
	if Global.mouse_hovering_count > 0:
		Global.mouse_hovering_count -= 1


func _on_UpdateMessageButton_pressed():
	hide()
	$AudioStreamPlayer2D.play()


func draw():
	modulate = Global.COLOR_TRANPARENT
	$Tween.interpolate_property(self, "modulate", Global.COLOR_TRANPARENT, Global.COLOR_DEFAULT, 1)
	$Tween.start()
	has_been_displayed = true
	visible = true


func hide():
	visible = false
	if Global.mouse_hovering_count > 0:
		Global.mouse_hovering_count -= 1


func _on_UpdateMessageButton_mouse_entered():
	Global.mouse_hovering_count += 1


func _on_UpdateMessageButton_mouse_exited():
	if Global.mouse_hovering_count > 0:
		Global.mouse_hovering_count -= 1

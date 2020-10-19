extends Node2D


var mouse_on_update_message_button: bool = false


func _ready():
	visible = false


func display_version_message():
	if not get_node("../..").chapter_has_begun:
		visible = true
		yield(get_node("UpdateMessageButton"), "pressed")
		visible = false


func _on_TextureButton_mouse_entered():
	Global.mouse_hovering_count += 1


func _on_TextureButton_mouse_exited():
	if Global.mouse_hovering_count > 0:
		Global.mouse_hovering_count -= 1

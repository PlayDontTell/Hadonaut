extends Control


onready var game_manager = get_node("..")

var mouse_on_update_message_button: bool = false


func _ready():
	$Fade.visible = true
	
	$NightAmbience.play(2.7)
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	Global.update_message_visible = true
	$Fade/AnimationPlayer.play("black_screen")
	yield(get_tree().create_timer(0.3),"timeout")
	$Fade/AnimationPlayer.play("fade_in")

	yield(get_node("NinePatchRect/UpdateMessageButton"), "pressed")
	$AudioStreamPlayer2D.play()
	
	$Fade/AnimationPlayer.play("fade_out")
	yield($Fade/AnimationPlayer, "animation_finished")
	$Tween.interpolate_property($NightAmbience, "volume_db", 0, -60, 1,
		Tween.TRANS_LINEAR,Tween.EASE_IN_OUT)
	$Tween.start()
	yield(get_tree().create_timer(1),"timeout")
	Global.update_message_visible = false
	game_manager.load_scene(game_manager.first_chapter)
	
	
func _on_TextureButton_mouse_entered():
	Global.mouse_hovering_count += 1


func _on_TextureButton_mouse_exited():
	if Global.mouse_hovering_count > 0:
		Global.mouse_hovering_count -= 1


func _on_UpdateMessage_meta_clicked(meta):
# warning-ignore:return_value_discarded
	OS.shell_open(meta)


# warning-ignore:unused_argument
func _on_UpdateMessage_meta_hover_started(meta):
	Global.force_point_cursor = true
	Global.mouse_hovering_count += 1


# warning-ignore:unused_argument
func _on_UpdateMessage_meta_hover_ended(meta):
	Global.force_point_cursor = false
	if Global.mouse_hovering_count > 0:
		Global.mouse_hovering_count -= 1

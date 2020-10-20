extends Node2D


signal hslider_moved(value)
signal vslider_moved(value)


onready var pad = get_node("..")
onready var ui = pad.get_node("..")

# warning-ignore:unused_argument
func _process(delta):
	var cursor_relative = get_viewport().get_mouse_position() - Vector2(240, 130)

	if visible and not Global.menu_visible:
		
		var hslider = $HSlider
		# Horizontal position of the HSlider.
		if cursor_relative.x <= 50 and cursor_relative.x >= -50 and hslider.position.x != cursor_relative.x:
			hslider.position.x = cursor_relative.x
			$HSliderSound.play()
		elif cursor_relative.x > 50:
			hslider.position.x = 50
		elif cursor_relative.x < -50:
			hslider.position.x = -50
		# Vertical position of the HSlider.
		if cursor_relative.x < -35 or cursor_relative.x > 32:
			hslider.position.y = 79
		elif cursor_relative.x > -35 and cursor_relative.x < 32:
			hslider.position.y = 80
			
		var vslider = $VSlider
		# Horizontal position of the VSlider.
		if cursor_relative.y <= 23 and cursor_relative.y >= -55 and vslider.position.y != cursor_relative.y:
			vslider.position.y = cursor_relative.y
			$VSliderSound.play()
		elif cursor_relative.y > 23:
			vslider.position.y = 23
		elif cursor_relative.y < -55:
			vslider.position.y = -55
		# Vertical position of the VSlider.
		if cursor_relative.y < -55:
			vslider.position.x = -163
		elif cursor_relative.y < -16 and cursor_relative.y > -42:
			vslider.position.x = -164
		elif cursor_relative.y > -16 and cursor_relative.y < 4:
			vslider.position.x = -163	
		elif cursor_relative.y > 4 and cursor_relative.y < 16:
			vslider.position.x = -162
		elif cursor_relative.y > 16:
			vslider.position.x = -161
		
		var new_v_slider_value = (vslider.position.y - 23) / -78
		if pad.v_slider_value != new_v_slider_value:
			pad.v_slider_value = new_v_slider_value
			emit_signal("vslider_moved", pad.v_slider_value)
		
		var new_h_slider_value = (50 + hslider.position.x) / 100
		if pad.h_slider_value != new_h_slider_value:
			pad.h_slider_value = new_h_slider_value
			emit_signal("hslider_moved", pad.h_slider_value)


func _on_PadButton_pressed():
	toggle_pad()


func _on_PadOffButton_pressed():
	if visible and get_tree().paused:
		toggle_pad()


func toggle_pad():
	var state = Global.pad_visible
	visible = not state
	
	if not state and pad.current_module != "":
		$AudioStreamPlayer2D.play()
	else:
		$AudioStreamPlayer2D.stop()
	
	Global.pad_visible = not state
# warning-ignore:standalone_ternary
	Global.toggle_pause_off() if state else Global.toggle_pause_on()
# warning-ignore:standalone_ternary
	$PadClose.play() if state else $PadOpen.play()


func _on_PadButton_mouse_entered():
	Global.mouse_hovering_count += 1
	Global.force_menu_cursor = true


func _on_PadButton_mouse_exited():
	if Global.mouse_hovering_count > 0:
		Global.mouse_hovering_count -= 1
	Global.force_menu_cursor = false


func _on_PadOffButton_mouse_entered():
	Global.mouse_hovering_count += 1


func _on_PadOffButton_mouse_exited():
	if Global.mouse_hovering_count > 0:
		Global.mouse_hovering_count -= 1


func _on_PadOffButton_hide():
	if Global.mouse_hovering_count > 0:
		Global.mouse_hovering_count -= 1

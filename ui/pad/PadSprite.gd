extends Node2D


signal hslider_moved(value)
signal vslider_moved(value)


onready var pad = get_node("..")
onready var ui = pad.get_node("..")

# warning-ignore:unused_argument
func _process(delta):
	if visible and not Global.menu_visible:
		
		$HSlider.position = find_pos("h") - pad.get_node("..").position
		$VSlider.position = find_pos("v") - pad.get_node("..").position
		
		
		var new_v_slider_value = ($VSlider.position.y - 81) / -149
		if pad.v_slider_value != new_v_slider_value:
			pad.v_slider_value = new_v_slider_value
			emit_signal("vslider_moved", pad.v_slider_value)
		
		var new_h_slider_value = (138 + $HSlider.position.x) / 253
		if pad.h_slider_value != new_h_slider_value:
			pad.h_slider_value = new_h_slider_value
			emit_signal("hslider_moved", pad.h_slider_value)


func find_pos(h_or_v):
	var mouse_position = Vector2(int(get_global_mouse_position().x), 
									int(get_global_mouse_position().y)) - Vector2(240, 130)
	var point_list = []
	var n = 0
	
	if h_or_v == "h":
		point_list = $HLine.points
		
		while mouse_position.x > point_list[n].x and n < point_list.size() - 1:
			n += 1
		
		if n == 0:
			return point_list[0]
		elif n < point_list.size() - 1:
			return Vector2(mouse_position.x, thales(mouse_position, point_list[n-1], point_list[n], h_or_v))
		else:
			return point_list[-1]
		
	elif h_or_v == "v":
		point_list = $VLine.points
		
		while mouse_position.y > point_list[n].y and n < point_list.size() - 1:
			n += 1
		
		if n == 0:
			return point_list[0] - Vector2(1, 0)
		elif n < point_list.size() - 1:
			return Vector2(thales(mouse_position, point_list[n-1], point_list[n], h_or_v), mouse_position.y)
		else:
			return point_list[-2]


func thales(mouse_position, point_A, point_B, h_or_v):
	if h_or_v == "h":
		return - abs((mouse_position.x - point_A.x) / (point_B.x 
			- point_A.x)) * (point_A.y - point_B.y) + min(point_A.y, point_B.y)
	elif h_or_v == "v":
		return - abs((mouse_position.y - point_A.y) / (point_B.y 
			- point_A.y)) * (point_A.x - point_B.x) + min(point_A.x, point_B.x)


func _on_PadButton_pressed():
	pass


func _on_PadOffButton_pressed():
	pass


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

extends Node2D


signal hslider_moved(value)
signal vslider_moved(value)


onready var pad = get_node("..")
onready var drawers = get_node("../../..")
onready var handle = drawers.get_node("PadDrawer/PadHandle")

var v_slider_offset = Vector2(0, 6)
var last_hslider_pos: Vector2
var new_hslider_pos: Vector2
var last_vslider_pos: Vector2
var new_vslider_pos: Vector2
var global_mouse_offset: Vector2 = Vector2(239, 97)


func _ready():
	$HLine.visible = false
	$VLine.visible = false
	$HSlider.position = find_pos("h") - pad.get_node("..").position
	$VSlider.position = find_pos("v") + handle.position - 1 * v_slider_offset


# warning-ignore:unused_argument
func _input(event):
	if event is InputEventMouseMotion and Global.pad_drawer_opened:
		new_hslider_pos = find_pos("h") - pad.get_node("..").position
		new_vslider_pos = find_pos("v") - pad.get_node("..").position
	
		if not last_hslider_pos == new_hslider_pos:
			$HSlider.position = new_hslider_pos
			$HSliderSound.play()
			last_hslider_pos = new_hslider_pos
			
		if not last_vslider_pos == new_vslider_pos:
			$VSlider.position = new_vslider_pos
			$VSliderSound.play()
			last_vslider_pos = new_vslider_pos
	
	var new_v_slider_value = ($VSlider.position.y - 56) / -114
	if pad.v_slider_value != new_v_slider_value:
		pad.v_slider_value = new_v_slider_value
		emit_signal("vslider_moved", pad.v_slider_value)
	
	var new_h_slider_value = (119 + $HSlider.position.x) / 238
	if pad.h_slider_value != new_h_slider_value:
		pad.h_slider_value = new_h_slider_value
		emit_signal("hslider_moved", pad.h_slider_value)


func find_pos(h_or_v):
	var mouse_position = Vector2(int(get_global_mouse_position().x), 
						int(get_global_mouse_position().y)) - global_mouse_offset
	var point_list = []
	var n = 0
	
	if h_or_v == "h":
		point_list = $HLine.points
		
		while mouse_position.x > point_list[n].x and n < point_list.size() - 1:
			n += 1
		
		if n == 0:
			return point_list[0]
		elif n < point_list.size() - 1:
			return Vector2(mouse_position.x, thales(mouse_position, 
											point_list[n-1], point_list[n], h_or_v))
		else:
			return point_list[-1]
		
	elif h_or_v == "v":
		point_list = $VLine.points
		
		while mouse_position.y > point_list[n].y and n < point_list.size() - 1:
			n += 1
		
		if n == 0:
			return point_list[0] - v_slider_offset
		elif n < point_list.size() - 1:
			return Vector2(thales(mouse_position, point_list[n-1],
														 point_list[n], h_or_v)
				, mouse_position.y - v_slider_offset.y)
		else:
			return point_list[-2] - v_slider_offset


func thales(mouse_position, point_A, point_B, h_or_v):
	if h_or_v == "h":
		return - abs((mouse_position.x - point_A.x) / (point_B.x 
			- point_A.x)) * (point_A.y - point_B.y) + min(point_A.y, point_B.y)
	elif h_or_v == "v":
		return - abs((mouse_position.y - point_A.y) / (point_B.y 
			- point_A.y)) * (point_A.x - point_B.x) + point_A.x


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

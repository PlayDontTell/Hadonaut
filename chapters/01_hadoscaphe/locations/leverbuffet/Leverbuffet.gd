extends Node2D


onready var current_chapter = get_node("..")
onready var inventory = get_node("../UI/Inventory")

var cable_section = preload("res://chapters/01_hadoscaphe/locations/leverbuffet/Cable.tscn")
var cable_joint = preload("res://chapters/01_hadoscaphe/locations/leverbuffet/CableJoint.tscn")
var cable_pin = preload("res://chapters/01_hadoscaphe/locations/leverbuffet/CablePin.tscn")
var on_red_cable: bool = false
var cable_selected: String = ""
var left_door_screws = []
var right_door_screws = []
var mouse_on_leftdoor: bool = false
var mouse_on_rightdoor: bool = false


func _ready():
	$DoorLeft.visible = true
	$DoorRight.visible = true
	
# warning-ignore:standalone_ternary
	open_left_door(0) if current_chapter.left_buffet_door else close_left_door(0)
# warning-ignore:standalone_ternary
	open_right_door(0) if current_chapter.right_buffet_door else close_right_door(0)
	
	$Screws.set_frame(0)
	$Screwdriver.visible = not current_chapter.screwdriver_taken
	$Screwdriver/CollisionPolygon2D.disabled = current_chapter.screwdriver_taken
	
	if current_chapter.maintenance_lever:
		$LeverTop.position = Vector2(177, 12)
		$LeverBack.position = Vector2(169, 71)
	else:
		$LeverTop.position = Vector2(141, 13)
		$LeverBack.position = Vector2(133, 72)
	
	initialize_light()


func initialize_light():
	$AnimationPlayer.play(current_chapter.ship_power)
	$Screwdriver/AnimationPlayer.play(current_chapter.ship_power)
	initialize_unscrewed_screws()
	$DoorLeft/LeverBuffetScrew.initialize_light(current_chapter.ship_power)
	$DoorLeft/LeverBuffetScrew2.initialize_light(current_chapter.ship_power)
	$DoorLeft/LeverBuffetScrew3.initialize_light(current_chapter.ship_power)
	$DoorLeft/LeverBuffetScrew4.initialize_light(current_chapter.ship_power)
	$DoorRight/LeverBuffetScrew.initialize_light(current_chapter.ship_power)
	$DoorRight/LeverBuffetScrew2.initialize_light(current_chapter.ship_power)
	$DoorRight/LeverBuffetScrew3.initialize_light(current_chapter.ship_power)
	$DoorRight/LeverBuffetScrew4.initialize_light(current_chapter.ship_power)


func refresh_door():
	var nbr_of_screws_on_door_left: int = 0
	var nbr_of_screws_on_door_right: int = 0
	
	if not $DoorLeft/LeverBuffetScrew.visible:
		nbr_of_screws_on_door_left += 1
	if not $DoorLeft/LeverBuffetScrew2.visible:
		nbr_of_screws_on_door_left += 1
	if not $DoorLeft/LeverBuffetScrew3.visible:
		nbr_of_screws_on_door_left += 1
	if not $DoorLeft/LeverBuffetScrew4.visible:
		nbr_of_screws_on_door_left += 1
		
	if not $DoorRight/LeverBuffetScrew.visible:
		nbr_of_screws_on_door_right += 1
	if not $DoorRight/LeverBuffetScrew2.visible:
		nbr_of_screws_on_door_right += 1
	if not $DoorRight/LeverBuffetScrew3.visible:
		nbr_of_screws_on_door_right += 1
	if not $DoorRight/LeverBuffetScrew4.visible:
		nbr_of_screws_on_door_right += 1
	
	if nbr_of_screws_on_door_left == 4 and $DoorLeft.modulate == Color(1, 1, 1, 1):
		open_left_door(0.8)
		$SlidingPanelSound.play()
	if nbr_of_screws_on_door_right == 4 and $DoorRight.modulate == Color(1, 1, 1, 1):
		open_right_door(0.8)
		$SlidingPanelSound.play()
	
	refresh_unscrewed_screws()


func refresh_unscrewed_screws():
	initialize_unscrewed_screws()
	$ScrewSound.pitch_scale = 0.75 + rand_range(0, 0.5)
	$ScrewSound.play()


func initialize_unscrewed_screws():
	var light = 0 if current_chapter.ship_power == "day" else 9
	var nbr_of_unscrewed_screws: int = 0
	
	for i in current_chapter.buffet_screws:
		if not i:
			nbr_of_unscrewed_screws += 1
	
	$Screws.frame = nbr_of_unscrewed_screws + light


func open_left_door(trans_duration):
	current_chapter.left_buffet_door = true
	$Tween.interpolate_property($DoorLeft, "modulate", Color(1, 1, 1, 1)
	, Color(1, 1, 1, 0), trans_duration, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	$Tween.interpolate_property($DoorLeftDetached, "modulate", Color(1, 1, 1, 0)
	, Color(1, 1, 1, 1), trans_duration, Tween.TRANS_LINEAR, Tween.EASE_IN)
	$DoorLeftDetached/LeftArea2D/CollisionPolygon2D.disabled = false
	$Tween.start()


func close_left_door(trans_duration):
	current_chapter.left_buffet_door = false
	$Tween.interpolate_property($DoorLeft, "modulate", Color(1, 1, 1, 0)
	, Color(1, 1, 1, 1), trans_duration, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	$Tween.interpolate_property($DoorLeftDetached, "modulate", Color(1, 1, 1, 1)
	, Color(1, 1, 1, 0), trans_duration, Tween.TRANS_LINEAR, Tween.EASE_IN)
	$DoorLeftDetached/LeftArea2D/CollisionPolygon2D.disabled = true
	$Tween.start()


func open_right_door(trans_duration):
	current_chapter.right_buffet_door = true
	$Tween.interpolate_property($DoorRight, "modulate", Color(1, 1, 1, 1)
	, Color(1, 1, 1, 0), trans_duration, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	$Tween.interpolate_property($DoorRightDetached, "modulate", Color(1, 1, 1, 0)
	, Color(1, 1, 1, 1), trans_duration, Tween.TRANS_LINEAR, Tween.EASE_IN)
	$DoorRightDetached/RightArea2D/CollisionPolygon2D.disabled = false
	$Tween.start()


func close_right_door(trans_duration):
	current_chapter.right_buffet_door = false
	$Tween.interpolate_property($DoorRight, "modulate", Color(1, 1, 1, 0)
	, Color(1, 1, 1, 1), trans_duration, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	$Tween.interpolate_property($DoorRightDetached, "modulate", Color(1, 1, 1, 1)
	, Color(1, 1, 1, 0), trans_duration, Tween.TRANS_LINEAR, Tween.EASE_IN)
	$DoorRightDetached/RightArea2D/CollisionPolygon2D.disabled = true
	$Tween.start()


# warning-ignore:unused_argument
# warning-ignore:unused_argument
func _on_Screwdriver_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed:
		current_chapter.screwdriver_taken = true
		$Screwdriver.visible = false
		$Screwdriver/CollisionPolygon2D.disabled = true
		inventory.add("screwdriver", Vector2(222, 170))


# warning-ignore:unused_argument
# warning-ignore:unused_argument
func _on_LeftArea2D_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed:
		close_left_door(0.8)
		$DoorLeft/LeverBuffetScrew.draw()
		$DoorLeft/LeverBuffetScrew2.draw()
		$DoorLeft/LeverBuffetScrew3.draw()
		$DoorLeft/LeverBuffetScrew4.draw()
		$SlidingPanelSound.play()


# warning-ignore:unused_argument
# warning-ignore:unused_argument
func _on_RightArea2D_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed:
		close_right_door(0.8)
		$DoorRight/LeverBuffetScrew.draw()
		$DoorRight/LeverBuffetScrew2.draw()
		$DoorRight/LeverBuffetScrew3.draw()
		$DoorRight/LeverBuffetScrew4.draw()
		$SlidingPanelSound.play()

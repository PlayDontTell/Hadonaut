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
var free_screws: int = 0


func _ready():
	$DoorLeft.visible = true
	$DoorRight.visible = true
	$DoorLeftDetached.modulate = Color(1, 1, 1, 0)
	$DoorRightDetached.modulate = Color(1, 1, 1, 0)
	$Screws.set_frame(0)
	$Screwdriver.visible = not current_chapter.screwdriver_taken
	$Screwdriver/CollisionPolygon2D.disabled = current_chapter.screwdriver_taken
	
	initialize_light()


func initialize_light():
	$AnimationPlayer.play(current_chapter.ship_power)
	$Screwdriver/AnimationPlayer.play(current_chapter.ship_power)
	initialize_screws()
	$DoorLeft/LeverBuffetScrew.initialize_light(current_chapter.ship_power)
	$DoorLeft/LeverBuffetScrew2.initialize_light(current_chapter.ship_power)
	$DoorLeft/LeverBuffetScrew3.initialize_light(current_chapter.ship_power)
	$DoorLeft/LeverBuffetScrew4.initialize_light(current_chapter.ship_power)
	$DoorRight/LeverBuffetScrew.initialize_light(current_chapter.ship_power)
	$DoorRight/LeverBuffetScrew2.initialize_light(current_chapter.ship_power)
	$DoorRight/LeverBuffetScrew3.initialize_light(current_chapter.ship_power)
	$DoorRight/LeverBuffetScrew4.initialize_light(current_chapter.ship_power)


func initialize_screws():
	var light
	if current_chapter.ship_power == "day":
		light = 0
	else:
		light = 9
	$Screws.set_frame(free_screws + light)


func refresh_door(door, screw):
	match door:
		"left":
			if not screw in left_door_screws:
				left_door_screws.push_back(screw)
				free_screws += 1
				initialize_screws()
				$ScrewSound.pitch_scale = 0.75 + rand_range(0, 0.5)
				$ScrewSound.play()
		"right":
			if not screw in right_door_screws:
				right_door_screws.push_back(screw)
				free_screws += 1
				initialize_screws()
				$ScrewSound.pitch_scale = 0.75 + rand_range(0, 0.5)
				$ScrewSound.play()
	
	if left_door_screws.size() == 4 and $DoorLeft.modulate == Color(1, 1, 1, 1):
		$Tween.interpolate_property($DoorLeft, "modulate", Color(1, 1, 1, 1)
		, Color(1, 1, 1, 0), 0.8, Tween.TRANS_LINEAR, Tween.EASE_OUT)
		$Tween.interpolate_property($DoorLeftDetached, "modulate", Color(1, 1, 1, 0)
		, Color(1, 1, 1, 1), 0.8, Tween.TRANS_LINEAR, Tween.EASE_IN)
		$Tween.start()
		$SlidingPanelSound.play()
	if right_door_screws.size() == 4 and $DoorRight.modulate == Color(1, 1, 1, 1):
		$Tween.interpolate_property($DoorRight, "modulate", Color(1, 1, 1, 1)
		, Color(1, 1, 1, 0), 0.8, Tween.TRANS_LINEAR, Tween.EASE_OUT)
		$Tween.interpolate_property($DoorRightDetached, "modulate", Color(1, 1, 1, 0)
		, Color(1, 1, 1, 1), 0.8, Tween.TRANS_LINEAR, Tween.EASE_IN)
		$Tween.start()
		$SlidingPanelSound.play()


# warning-ignore:unused_argument
# warning-ignore:unused_argument
func _on_Screwdriver_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed:
		current_chapter.screwdriver_taken = true
		$Screwdriver.visible = false
		$Screwdriver/CollisionPolygon2D.disabled = true
		inventory.add("screwdriver", Vector2(222, 170))

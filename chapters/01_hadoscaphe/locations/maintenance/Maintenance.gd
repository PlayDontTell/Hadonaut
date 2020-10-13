extends Node2D


onready var current_chapter = get_node("..")
onready var inventory = get_node("../UI/Inventory")


func _ready():
	Global.room_name = "maintenance"
	# Initialization
	current_chapter.set_ship_power(current_chapter.ship_power)
	# Left door initialization.
	$LeftDoorButton.set_state()
	$DoorLeft.is_active = $LeftDoorButton.is_active
	$DoorLeft.initialize()
	
	$Screwdriver.visible = not current_chapter.screwdriver_taken


func initialize_light():
	# Tint the objects which aren't the set.
	if current_chapter.ship_power == "day":
		$LeftDoorButton/Sprite.modulate = Color(1,1,1)
		$DoorLeft/AnimationPlayer.play("day")
		$Background/AnimationPlayer.play("day")
	else:
		$LeftDoorButton/Sprite.modulate = Color(0.5,0.5,0.7)
		$DoorLeft/AnimationPlayer.play("night")
		$Background/AnimationPlayer.play("night")
	# initialize the animated objects (animations).
# warning-ignore:standalone_ternary
	toggle_lever_on() if current_chapter.ship_power == "day" else toggle_lever_off()


func _on_LeftDoorButton_order_interaction(action_name, position_ordered, flip_h, action_type):
	var action = $Char.execute_action(action_name, position_ordered, flip_h, action_type)
	yield(action, "completed")
	if $Char.action == action_name + "_completed":
		$LeftDoorButton/ButtonSound.play()
		$DoorLeft.command()


func _on_Lever_order_interaction(action_name, position_ordered, flip_h, action_type):
	var action = $Char.execute_action(action_name, position_ordered, flip_h, action_type)
	yield(action, "completed")
	if $Char.action == action_name + "_completed":
		$Lever/LeverSound.play()
		var state = current_chapter.ship_power
		match state:
			"night":
				toggle_lever_on()
				current_chapter.set_ship_power("day")
				yield(get_tree().create_timer(0.5), "timeout")
				current_chapter.get_node("ChapterRes/Atmo/EngineStart").play()
				
				current_chapter.had_doors[0][0] = true
				
				$LeftDoorButton.set_state()
				$DoorLeft.is_active = $LeftDoorButton.is_active
				$DoorLeft.initialize()
				
			"day":
				toggle_lever_off()
				current_chapter.set_ship_power("night")
				current_chapter.get_node("ChapterRes/Atmo/EngineStart").stop()
				
				current_chapter.had_doors[0][0] = false
				current_chapter.had_doors[1][0] = false
				current_chapter.had_doors[2][0] = false
				current_chapter.had_doors[3][0] = false
				current_chapter.had_doors[4][0] = false
				current_chapter.had_doors[5][0] = false
				current_chapter.had_doors[6][0] = false
				
				$LeftDoorButton.set_state()
				$DoorLeft.is_active = $LeftDoorButton.is_active
				$DoorLeft.initialize()


func toggle_lever_on():
	$Lever/Animation.play("on")


func toggle_lever_off():
	$Lever/Animation.play("off")




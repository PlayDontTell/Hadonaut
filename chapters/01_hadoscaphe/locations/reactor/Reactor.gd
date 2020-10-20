extends Node2D


onready var current_chapter = get_node("..")
onready var inventory = get_node("../UI/Inventory")


func _ready():
	Global.room_name = "flora"
	# Initialization
	current_chapter.set_ship_power(current_chapter.ship_power)
	# Left door initialization.
	$RightDoorButton.set_state()
	$DoorRight.is_active = $RightDoorButton.is_active
	$DoorRight.initialize()


func initialize_light():
	# Tint the objects which aren't the set.
	if current_chapter.ship_power == "day":
		$RightDoorButton/Sprite.modulate = Global.COLOR_DEFAULT
	else:
		$RightDoorButton/Sprite.modulate = Global.COLOR_BLUE_TINTED
	$DoorRight/AnimationPlayer.play(current_chapter.ship_power)
	$Background/AnimationPlayer.play(current_chapter.ship_power)
	$Foreground/AnimationPlayer.play(current_chapter.ship_power)
	$Engine/AnimationPlayer.play(current_chapter.ship_power)


func _on_RightDoorButton_order_interaction(action_name, position_ordered, flip_h, action_type):
	var action = $Char.execute_action(action_name, position_ordered, flip_h, action_type)
	yield(action, "completed")
	if $Char.action == action_name + "_completed":
		$RightDoorButton/ButtonSound.play()
		$DoorRight.command()

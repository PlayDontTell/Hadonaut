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
	if current_chapter.pad_taken:
		$Pad.queue_free()


func initialize_light():
	# Tint the objects which aren't the set.
	if current_chapter.ship_power == "day":
		$RightDoorButton/Sprite.modulate = Global.COLOR_DEFAULT
	else:
		$RightDoorButton/Sprite.modulate = Global.COLOR_BLUE_TINTED
	# initialize the animated objects (animations).
	$AnimationPlayer.play(current_chapter.ship_power)
	if not current_chapter.pad_taken:
		$Pad/Animation.play(current_chapter.ship_power)


func _on_RightDoorButton_order_interaction(action_name, position_ordered, flip_h, action_type):
	var action = $Char.execute_action(action_name, position_ordered, flip_h, action_type)
	yield(action, "completed")
	if $Char.action == action_name + "_completed":
		$RightDoorButton/ButtonSound.play()
		$DoorRight.command()


func _on_Pad_order_interaction(action_name, position_ordered, flip_h, action_type):
	var action = $Char.execute_action(action_name, position_ordered, flip_h, action_type)
	yield(action, "completed")
	if $Char.action == action_name + "_completed":
		$Pad.queue_free()
		current_chapter.get_node("UI/HUD/PadButton").visible = true
		current_chapter.pad_taken = true
		inventory.add("map_module", Vector2(231, 129))

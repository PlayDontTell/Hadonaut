extends Node2D


onready var current_chapter = get_node("..")
onready var inventory = get_node("../UI/Inventory")


func _ready():
	# Initialization
	current_chapter.set_ship_power(current_chapter.ship_power)
	# Left door initialization.
	$RightDoorButton.set_state()
	$DoorRight.is_active = $RightDoorButton.is_active
	$DoorRight.initialize()


# warning-ignore:unused_argument
func _process(delta):
	var distance_to_lights = ($Char/Sprite.position.x - 200) / 500
	$Char.modulate = Color(1.4 - distance_to_lights, 1, 1, 1)


func initialize_light():
	# Tint the objects which aren't the set.
	$RightDoorButton/Sprite.modulate = Global.COLOR_BLUE_TINTED
#	$Char.modulate = Global.COLOR_RED_TINTED


func _on_RightDoorButton_order_interaction(action_name, position_ordered, flip_h, action_type):
	var action = $Char.execute_action(action_name, position_ordered, flip_h, action_type)
	yield(action, "completed")
	if $Char.action == action_name + "_completed":
		$RightDoorButton/ButtonSound.play()
		$DoorRight.command()

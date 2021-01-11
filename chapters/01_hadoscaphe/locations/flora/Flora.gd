extends Node2D


onready var current_chapter = get_node("..")
onready var hud = current_chapter.hud
onready var inventory = hud.inventory


func _ready():
	# Initialization
	current_chapter.set_ship_power(current_chapter.ship_power)
	# Left door initialization.
	$RightDoorButton.set_state()
	$DoorRight.is_active = $RightDoorButton.is_active
	$DoorRight.initialize()
	
	if current_chapter.pad_taken and current_chapter.map_module_taken:
		$PadAndModule.queue_free()
	else:
		$PadAndModule/PadInstanceSprite.visible = not current_chapter.pad_taken
		$PadAndModule/MapModuleInstanceSprite.visible = not current_chapter.map_module_taken


func initialize_light():
	var tint_int = 0
	# Tint the objects which aren't the set.
	if current_chapter.ship_power == "day":
		$RightDoorButton/Sprite.modulate = Global.COLOR_DEFAULT
	else:
		tint_int = 1
		$RightDoorButton/Sprite.modulate = Global.COLOR_BLUE_TINTED
	# initialize the animated objects (animations).
	$AnimationPlayer.play(current_chapter.ship_power)
	if not current_chapter.pad_taken:
		$PadAndModule/PadInstanceSprite.frame = tint_int
		$PadAndModule/PadInstanceSprite/Shade.frame = tint_int
	if not current_chapter.map_module_taken:
		$PadAndModule/MapModuleInstanceSprite.frame = tint_int
		$PadAndModule/MapModuleInstanceSprite/Shade.frame = tint_int


func _on_RightDoorButton_order_interaction(action_name, position_ordered, flip_h, action_type):
	var action = $Char.execute_action(action_name, position_ordered, flip_h, action_type)
	yield(action, "completed")
	if $Char.action == action_name + "_completed":
		$RightDoorButton/ButtonSound.play()
		$DoorRight.command()

extends Node2D


onready var current_chapter = get_node("..")
onready var hud = current_chapter.hud
onready var inventory = hud.inventory

var zone_0: bool = true
var is_sas_1_off: bool = true
var is_sas_2_off: bool = true
var is_sas_3_off: bool = true
var sas_duration: int = 2
var tween_curv = Tween.TRANS_SINE
var tween_ease = Tween.EASE_IN_OUT


func _ready():
	# Initialization
	current_chapter.set_ship_power(current_chapter.ship_power)
	# Initialization
	$TopDoorButton.set_state()
	$BottomDoorButton.set_state()
	$RightDoorButton.set_state()
	# Top door 1 initialization.
	$DoorTop1.initialize()
	# Top door 2 initialization.
	current_chapter.had_doors[$DoorTop2.door_id][0] = $DoorTop1.is_active
	current_chapter.had_doors[$DoorTop2.door_id][1] = not $DoorTop1.is_opened
	$DoorTop2.initialize()
	# Bottom door 1 initialization.
	$DoorBottom1.initialize()
	# Bottom door 2 initialization.
	current_chapter.had_doors[$DoorBottom2.door_id][0] = $DoorBottom1.is_active
	current_chapter.had_doors[$DoorBottom2.door_id][1] = not $DoorBottom1.is_opened
	$DoorBottom2.initialize()
	# Right door 1 initialization.
	$DoorRight1.initialize()
	# Right door 2 initialization.
	current_chapter.had_doors[$DoorRight2.door_id][0] = $DoorRight1.is_active
	current_chapter.had_doors[$DoorRight2.door_id][1] = not $DoorRight1.is_opened
	$DoorRight2.initialize()
	
	if $DoorTop2.is_opened:
		$Masks/Mask1.modulate = Global.COLOR_DEFAULT
	if $DoorBottom2.is_opened:
		$Masks/Mask2.modulate = Global.COLOR_DEFAULT
	if $DoorRight2.is_opened:
		$Masks/Mask3.modulate = Global.COLOR_DEFAULT
	
	if not $DoorTop2.is_opened or not $DoorBottom2.is_opened or not $DoorRight2.is_opened:
		zone_0 = false
		$Masks/Mask0.modulate = Global.COLOR_DEFAULT
	else:
		zone_0 = true
	initialize_navmesh()
	
	$Smoke.emitting = false
	
	initialize_light()


func _process(_delta):
	# Making sure that the Foreground gets behind Char when he's in front of it.
	var char_position = $Char/Sprite.position
	if char_position.y > 149 and char_position.x <= 322 and char_position.x > 222:
		$Char/Sprite.z_index = +1
	else:
		$Char/Sprite.z_index = 0


# Function to adapt the navmesh to the accessibles areas to Char.
func initialize_navmesh():
	var navmap = $Char/Navigation2D/NavigationPolygonInstance
	# Resetting the navmesh.
	navmap.get_navigation_polygon().clear_outlines()
	navmap.get_navigation_polygon().clear_polygons()
	# Adding the active zones' polygons.
	if zone_0:
		navmap.get_navigation_polygon().add_outline($Polygons/NavMesh0.polygon)
	navmap.get_navigation_polygon().add_outline($Polygons/NavMesh1.polygon)
	navmap.get_navigation_polygon().add_outline($Polygons/NavMesh2.polygon)
	navmap.get_navigation_polygon().add_outline($Polygons/NavMesh3.polygon)
	# Rendering the new navmesh
	navmap.get_navigation_polygon().make_polygons_from_outlines()
	navmap.enabled = false
	navmap.enabled = true


func initialize_light():
	$Set/AnimationPlayer.play(current_chapter.ship_power)
	# Tint the objects which aren't the set.
	if current_chapter.ship_power == "day":
		# Buttons :
		$TopDoorButton/Sprite.modulate = Global.COLOR_DEFAULT
		$BottomDoorButton/Sprite.modulate = Global.COLOR_DEFAULT
		$RightDoorButton/Sprite.modulate = Global.COLOR_DEFAULT
	else:
		# Buttons :
		$TopDoorButton/Sprite.modulate = Global.COLOR_BLUE_TINTED
		$BottomDoorButton/Sprite.modulate = Global.COLOR_BLUE_TINTED
		$RightDoorButton/Sprite.modulate = Global.COLOR_BLUE_TINTED
	# Doors :
	$DoorTop1/AnimationPlayer.play(current_chapter.ship_power)
	$DoorTop2/AnimationPlayer.play(current_chapter.ship_power)
	$DoorRight1/AnimationPlayer.play(current_chapter.ship_power)
	$DoorRight2/AnimationPlayer.play(current_chapter.ship_power)
	$DoorBottom1/AnimationPlayer.play(current_chapter.ship_power)
	$DoorBottom2/AnimationPlayer.play(current_chapter.ship_power)
	# Rest :
	$Background/AnimationPlayer.play(current_chapter.ship_power)
	$Foreground/AnimationPlayer.play(current_chapter.ship_power)


func _on_TopDoorButton_order_interaction(action_name, position_ordered, flip_h, action_type):
	var action = $Char.execute_action(action_name, position_ordered, flip_h, action_type)
	yield(action, "completed")
	if $Char.action == action_name + "_completed":
		use_sas(1, is_sas_1_off, $TopDoorButton, $DoorTop1, $DoorTop2, Vector2(113, 48))


func _on_BottomDoorButton_order_interaction(action_name, position_ordered, flip_h, action_type):
	var action = $Char.execute_action(action_name, position_ordered, flip_h, action_type)
	yield(action, "completed")
	if $Char.action == action_name + "_completed":
		use_sas(2, is_sas_2_off, $BottomDoorButton, $DoorBottom1, $DoorBottom2, Vector2(168, 149))


func _on_RightDoorButton_order_interaction(action_name, position_ordered, flip_h, action_type):
	var action = $Char.execute_action(action_name, position_ordered, flip_h, action_type)
	yield(action, "completed")
	if $Char.action == action_name + "_completed":
		use_sas(3, is_sas_3_off, $RightDoorButton, $DoorRight1, $DoorRight2, Vector2(367, 85))


func smoke(pos):
	$Smoke.position = pos
	yield(get_tree().create_timer(0.9), "timeout")
	$Smoke/AudioStreamPlayer2D.play()
	$Smoke.emitting = true
	yield(get_tree().create_timer(0.8), "timeout")
	$Smoke.emitting = false


func use_sas(sas_no, sas_var, button, door1, door2, smoke_position):
		button.get_node("ButtonSound").play()
		
		var state_command = sas_var
		if button.is_active:
			if state_command and door1.is_active:
				sas_var = false
				
				var state_door = door1.is_opened
				var state_door2 = door2.is_opened
				if state_door and not state_door2:
					current_chapter.had_doors[button.door_id][0] = false
					button.set_state()
					
					door1.command()
					smoke(smoke_position)
					yield(get_tree().create_timer(sas_duration), "timeout")
					door2.command()
					
					$Tween.interpolate_property($Masks/Mask0, "modulate", $Masks/Mask0.modulate,
					Global.COLOR_TRANPARENT, 1,tween_curv , tween_ease)
					if not sas_no == 1:
						$Tween.interpolate_property($Masks/Mask1, "modulate", $Masks/Mask1.modulate,
						Global.COLOR_TRANPARENT, 1,tween_curv , tween_ease)
					if not sas_no == 2:
						$Tween.interpolate_property($Masks/Mask2, "modulate", $Masks/Mask2.modulate,
						Global.COLOR_TRANPARENT, 1,tween_curv , tween_ease)
					if not sas_no == 3:
						$Tween.interpolate_property($Masks/Mask3, "modulate", $Masks/Mask3.modulate,
						Global.COLOR_TRANPARENT, 1,tween_curv , tween_ease)
					$Tween.start()
					
					yield(get_tree().create_timer(1.01), "timeout")
					sas_var = true
					zone_0 = true
					initialize_navmesh()
					
					current_chapter.had_doors[button.door_id][0] = true
					button.set_state()
				elif not state_door and state_door2:
					current_chapter.had_doors[button.door_id][0] = false
					button.set_state()
					
					zone_0 = false
					initialize_navmesh()
					door2.command()
					smoke(smoke_position)
					
					$Tween.interpolate_property($Masks/Mask0, "modulate", $Masks/Mask0.modulate,
					Global.COLOR_DEFAULT, 1,tween_curv , tween_ease)
					if not sas_no == 1:
						$Tween.interpolate_property($Masks/Mask1, "modulate", $Masks/Mask1.modulate,
						Global.COLOR_DEFAULT, 1,tween_curv , tween_ease)
					if not sas_no == 2:
						$Tween.interpolate_property($Masks/Mask2, "modulate", $Masks/Mask2.modulate,
						Global.COLOR_DEFAULT, 1,tween_curv , tween_ease)
					if not sas_no == 3:
						$Tween.interpolate_property($Masks/Mask3, "modulate", $Masks/Mask3.modulate,
						Global.COLOR_DEFAULT, 1,tween_curv , tween_ease)
					$Tween.start()
					
					yield(get_tree().create_timer(sas_duration), "timeout")
					door1.command()
					yield(get_tree().create_timer(1.01), "timeout")
					sas_var = true
					
					current_chapter.had_doors[button.door_id][0] = true
					button.set_state()
			else:
				door1.get_node("DoorErrorSound").play()
		else:
			yield(get_tree().create_timer(0.2), "timeout")
			button.get_node("ButtonError").play()

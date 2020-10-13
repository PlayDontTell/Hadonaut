extends Node2D


onready var current_chapter = get_node("..")
onready var inventory = get_node("../UI/Inventory")
var char_is_fallen: bool = false
var char_is_risen: bool = false


func _ready():
	Global.room_name = "cryopod"
	# Initialization
	current_chapter.set_ship_power(current_chapter.ship_power)
	# Left door initialization.
	$LeftDoorButton.set_state()
	$DoorLeft.is_active = $LeftDoorButton.is_active
	$DoorLeft.initialize()
	# Right door initialization.
	$DoorRight.is_active = current_chapter.had_doors[$DoorRight.door_id][0]
	$DoorRight.is_opened = current_chapter.had_doors[$DoorRight.door_id][1]
	$DoorRight.initialize()
	
	$AwakeningAnimation/Area2D/CollisionShape2D.disabled = true
	var state = current_chapter.chapter_has_begun
	if not state:
		current_chapter.chapter_has_begun = true
		$CryopodDoor/AnimationPlayer.play("closed_" + current_chapter.ship_power)
		$Char.visible = false
		yield(get_tree().create_timer(0.5), "timeout")
		$CryopodDoor/AnimationPlayer.play("open_" + current_chapter.ship_power)
		yield(get_tree().create_timer(1), "timeout")
		$AwakeningAnimation.playing = true
		$AwakeningAnimation/FallSound.play()
		yield(get_tree().create_timer(1.3), "timeout")
		char_is_fallen = true
		$AwakeningAnimation/Area2D/CollisionShape2D.disabled = false
	else:
		$AwakeningAnimation.visible = false


func _process(_delta):
	if $Trap/Animation.assigned_animation == "opened_" + current_chapter.ship_power:
		var pos = $Char/Sprite.position
		if pos.x > 135 and pos.x < 208 and pos.y <= 151:
			$Trap/Sprite.z_index = 1
		else:
			$Trap/Sprite.z_index = 0


func initialize_light():
	# Tint the objects which aren't the set.
	if current_chapter.ship_power == "day":
		$LeftDoorButton/Sprite.modulate = Color(1,1,1)
		$AwakeningAnimation.modulate = Color(1,1,1)
		$Cloths/Sprite.modulate = Color(1,1,1)
	else:
		$LeftDoorButton/Sprite.modulate = Color(0.5,0.5,0.7)
		$AwakeningAnimation.modulate = Color(0.5,0.5,0.7)
		$Cloths/Sprite.modulate = Color(0.5,0.5,0.7)
	$DoorLeft/AnimationPlayer.play(current_chapter.ship_power)
	$DoorRight/AnimationPlayer.play(current_chapter.ship_power)
	$Background/AnimationPlayer.play(current_chapter.ship_power)
	var cryopod_door_state = "closed" if current_chapter.cryopod_door_closed else "opened"
	$CryopodDoor/AnimationPlayer.play(cryopod_door_state + "_" + current_chapter.ship_power)
	# initialize the animated objects (animations).
# warning-ignore:standalone_ternary
	close_closet_door() if current_chapter.closet_door_closed else open_closet_door()
# warning-ignore:standalone_ternary
	empty_closet() if current_chapter.cloths_taken else fill_closet()
# warning-ignore:standalone_ternary
	open_trap() if not current_chapter.trap_is_closed else close_trap()


func _on_LeftDoorButton_order_interaction(action_name, position_ordered, flip_h, action_type):
	var action = $Char.execute_action(action_name, position_ordered, flip_h, action_type)
	yield(action, "completed")
	if $Char.action == action_name + "_completed":
		$LeftDoorButton/ButtonSound.play()
		$DoorLeft.command()


func _on_ClosetDoor_order_interaction(action_name, position_ordered, flip_h, action_type):
	var action = $Char.execute_action(action_name, position_ordered, flip_h, action_type)
	yield(action, "completed")
	if $Char.action == action_name + "_completed":
		if not current_chapter.closet_door_closed:
			close_closet_door()
			$ClosetDoor/LockerClosing.play()
		else:
			open_closet_door()
			$ClosetDoor/LockerOpening.play()


func open_closet_door():
	$ClosetDoor/Animation.play("opened_" + current_chapter.ship_power)
	$ClosetDoor.flip_h = false
	$Cloths/CollisionShape2D.disabled = false
	current_chapter.closet_door_closed = false


func close_closet_door():
	$ClosetDoor/Animation.play("closed_" + current_chapter.ship_power)
	$ClosetDoor.flip_h = true
	$Cloths/CollisionShape2D.disabled = true
	current_chapter.closet_door_closed = true


func _on_Cloths_order_interaction(action_name, position_ordered, flip_h, action_type):
	var action = $Char.execute_action(action_name, position_ordered, flip_h, action_type)
	yield(action, "completed")
	if $Char.action == action_name + "_completed":
# warning-ignore:standalone_ternary
		empty_closet() if not current_chapter.cloths_taken else fill_closet()
		$Cloths/Cloths.play()
		$Char.initialize()


func empty_closet():
	CharState.dress_code = "fancypants"
	$Cloths/Sprite.visible = false
	current_chapter.cloths_taken = true
	if not current_chapter.trap_keys_taken:
		yield(get_tree().create_timer(1.4), "timeout")
		inventory.add("cryopod_trap_key", Vector2(326, 122))
		current_chapter.trap_keys_taken = true


func fill_closet():
	CharState.dress_code = "naked"
	$Cloths/Sprite.visible = true
	current_chapter.cloths_taken = false


func _on_Trap_order_interaction(action_name, position_ordered, flip_h, action_type):
	var action = $Char.execute_action(action_name, position_ordered, flip_h, action_type)
	yield(action, "completed")
	if $Char.action == action_name + "_completed":
		
		var is_closed = current_chapter.trap_is_closed
		var current_anim = $Char/CharAnimation.current_animation
		
		if is_closed and current_anim == str("pick_" + CharState.dress_code):
			if GlobalInventory.item_used == "cryopod_trap_key":
				inventory.remove("cryopod_trap_key")
				$Trap/TrapUnlocked.play()
				yield(get_tree().create_timer(0.4), "timeout")
				open_trap()
				$Trap/TrapOpened.play()
			else:
				$Trap/TrapLocked.play()
		elif not is_closed and current_anim == str("push_" + CharState.dress_code):
			close_trap()
			$Trap/TrapClosed.play()
			inventory.add("cryopod_trap_key", Vector2(183, 137))


func open_trap():
	$Trap/Animation.play("opened_" + current_chapter.ship_power)
	$GoToMaintenance.visible = true
	current_chapter.trap_is_closed = false


func close_trap():
	$Trap/Animation.play("closed_" + current_chapter.ship_power)
	$GoToMaintenance.visible = false
	current_chapter.trap_is_closed = true


# warning-ignore:unused_argument
# warning-ignore:unused_argument
func _on_Area2D_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			var state = char_is_risen
			if char_is_fallen and not state:
				char_is_risen = true
				yield(get_tree().create_timer(0.2), "timeout")
				$AwakeningAnimation/Area2D/CollisionShape2D.disabled = true
				$AwakeningAnimation.play("rise")
				$AwakeningAnimation/RiseSound.play()
				yield($AwakeningAnimation, "animation_finished")
				$AwakeningAnimation.visible = false
				$Char/Sprite.position = Vector2(255, 153)
				$Char.visible = true

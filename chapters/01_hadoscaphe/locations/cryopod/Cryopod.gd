extends Node2D


onready var current_chapter = get_node("..")
onready var inventory = get_node("../UI/Inventory")
var char_is_fallen: bool = false
var char_is_risen: bool = false


func _ready():
	# Initialization
	current_chapter.set_ship_power(current_chapter.ship_power)
	# doors initialization.
	$LeftDoorButton.set_state()
	$DoorLeft.initialize()
	$DoorRight.initialize()
	
	# Animation of Char falling out of the pod if the chapter just begun.
	var state = current_chapter.chapter_has_begun
	if not state:
		awakening_animation()
	else:
		$AwakeningAnimation.visible = false


func _process(_delta):
	if $Trap/Animation.assigned_animation == "opened_" + current_chapter.ship_power:
		var pos = $Char/Sprite.position
		if pos.x > 135 and pos.x < 208 and pos.y <= 151:
			$Trap/Sprite.z_index = 1
		else:
			$Trap/Sprite.z_index = 0


func awakening_animation():
	current_chapter.chapter_has_begun = true
	
	$CryopodDoor/AnimationPlayer.play("closed_" + current_chapter.ship_power)
	$Char.visible = false
	yield(get_tree().create_timer(1.5), "timeout")
	
	$Smoke.emitting = true
	yield(get_tree().create_timer(0.1), "timeout")
	$Smoke/AudioStreamPlayer2D.volume_db = -12
	$Smoke/AudioStreamPlayer2D.pitch_scale = 0.8
	$Smoke/AudioStreamPlayer2D.play()
	yield(get_tree().create_timer(0.5), "timeout")
	$Smoke.emitting = false
	yield(get_tree().create_timer(0.3), "timeout")
	
	yield(get_tree().create_timer(0.5), "timeout")
	$CryopodDoor/AnimationPlayer.play("open_" + current_chapter.ship_power)
	yield(get_tree().create_timer(1), "timeout")
	$AwakeningAnimation.playing = true
	$AwakeningAnimation/FallSound.play()
	yield(get_tree().create_timer(1.3), "timeout")
	char_is_fallen = true
	$AwakeningAnimation/Area2D/CollisionShape2D.disabled = false


func initialize_light():
	# Tint the objects which aren't the set.
	$LeftDoorButton/Sprite.modulate = Global.lighting_tint
	$AwakeningAnimation.modulate = Global.lighting_tint
	$Cloths/Sprite.modulate = Global.lighting_tint
	
	$AnimationPlayer.play(current_chapter.ship_power)
	
	var cryopod_door_state = "closed" if current_chapter.cryopod_door_closed else "opened"
	$CryopodDoor/AnimationPlayer.play(cryopod_door_state + "_" + current_chapter.ship_power)
	
	# initialize the animated objects (animations).
	$ClosetDoor.initialize_light()
# warning-ignore:standalone_ternary
	empty_closet() if current_chapter.cloths_taken else fill_closet()
	$Trap.initialize_light()


func _on_LeftDoorButton_order_interaction(action_name, position_ordered, flip_h, action_type):
	var action = $Char.execute_action(action_name, position_ordered, flip_h, action_type)
	yield(action, "completed")
	if $Char.action == action_name + "_completed":
		$LeftDoorButton/ButtonSound.play()
		$DoorLeft.command()


func _on_Trap_order_interaction(action_name, position_ordered, flip_h, action_type):
	var action = $Char.execute_action(action_name, position_ordered, flip_h, action_type)
	yield(action, "completed")
	if $Char.action == action_name + "_completed":
		
		var is_closed = current_chapter.trap_is_closed
		var current_anim = $Char/CharAnimation.current_animation
		
		if is_closed and current_anim == str("pick_" + CharState.dress_code):
			if GlobalInventory.item_used == "cryopod_trap_key":
				$Trap.unlock_trap()
				Global.add_to_playthrough_progress("You unlocked the trap.")
			else:
				$Trap.is_locked()
		elif not is_closed and current_anim == str("push_" + CharState.dress_code):
			$Trap.close_trap()


func _on_ClosetDoor_order_interaction(action_name, position_ordered, flip_h, action_type):
	var action = $Char.execute_action(action_name, position_ordered, flip_h, action_type)
	yield(action, "completed")
	if $Char.action == action_name + "_completed":
# warning-ignore:standalone_ternary
		$ClosetDoor.open_closet_door() if current_chapter.closet_door_closed else $ClosetDoor.close_closet_door()


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
		Global.add_to_playthrough_progress("You got the red key.")
		current_chapter.trap_keys_taken = true


func fill_closet():
	CharState.dress_code = "naked"
	$Cloths/Sprite.visible = true
	current_chapter.cloths_taken = false


# warning-ignore:unused_argument
# warning-ignore:unused_argument
func _on_Area2D_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			var state = char_is_risen
			if char_is_fallen and not state:
				Global.add_to_playthrough_progress("You have woken up Char.")
				char_is_risen = true
				yield(get_tree().create_timer(0.2), "timeout")
				$AwakeningAnimation/Area2D/CollisionShape2D.disabled = true
				$AwakeningAnimation.play("rise")
				$AwakeningAnimation/RiseSound.play()
				yield($AwakeningAnimation, "animation_finished")
				$AwakeningAnimation.visible = false
				$Char/Sprite.position = Vector2(255, 153)
				$Char.visible = true

extends "res://objects/InteractiveObject.gd"


onready var current_chapter = get_node("../..")
onready var cryopod = get_node("..")


func initialize_light():
# warning-ignore:standalone_ternary
	set_closet_door_closed() if current_chapter.closet_door_closed else set_closet_door_opened()
	


func open_closet_door():
	set_closet_door_opened()
	$LockerOpening.play()


func set_closet_door_opened():
	$Animation.play("opened_" + current_chapter.ship_power)
	flip_h = false
	cryopod.get_node("Cloths/CollisionShape2D").disabled = false
	current_chapter.closet_door_closed = false


func close_closet_door():
	set_closet_door_closed()
	$LockerClosing.play()


func set_closet_door_closed():
	$Animation.play("closed_" + current_chapter.ship_power)
	flip_h = true
	$CollisionShape2D.disabled = true
	current_chapter.closet_door_closed = true

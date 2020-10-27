extends "res://objects/InteractiveObject.gd"


onready var current_chapter = get_node("../..")
onready var inventory = get_node("../../UI/Inventory")
onready var cryopod = get_node("..")


func initialize_light():
# warning-ignore:standalone_ternary
	set_trap_opened() if not current_chapter.trap_is_closed else set_trap_closed()


func open_trap():
	set_trap_opened()
	$TrapOpened.play()


func set_trap_opened():
	$Animation.play("opened_" + current_chapter.ship_power)
	cryopod.get_node("GoToMaintenance").visible = true
	current_chapter.trap_is_closed = false


func close_trap():
	set_trap_closed()
	$TrapClosed.play()
	inventory.add("cryopod_trap_key", Vector2(183, 137))


func set_trap_closed():
	$Animation.play("closed_" + current_chapter.ship_power)
	cryopod.get_node("GoToMaintenance").visible = false
	current_chapter.trap_is_closed = true


func unlock_trap():
	inventory.remove("cryopod_trap_key")
	$TrapUnlocked.play()
	yield(get_tree().create_timer(0.4), "timeout")
	open_trap()
	

func is_locked():
	$TrapLocked.play()
